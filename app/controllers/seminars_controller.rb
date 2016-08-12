# frozen_string_literal: true

# Allow admins to track trainee seminar attendance.
class SeminarsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_administrator
  before_action :set_viewable_seminar, only: [:show]
  before_action :set_editable_seminar, only: [:edit, :update, :destroy]
  before_action :redirect_without_seminar, only: [:show, :edit, :update, :destroy]

  def attendance
    @applicants = Applicant.current.where(enrolled: true).where(status: (params[:status].blank? ? Applicant::STATUS.flatten.uniq : params[:status]))
    @year = params[:year].blank? ? (Time.zone.today.month > 6 ? Time.zone.today.year + 1 : Time.zone.today.year) : params[:year].to_i
    @seminars = Seminar.current.date_after(Date.parse("#{@year-1}-07-01")).date_before(Date.parse("#{@year}-06-30"))

    if params[:format] == 'csv'
      generate_csv(@applicants, @year, @seminars)
      return
    end
  end

  def attended
    @seminar = current_user.all_seminars.find_by_id(params[:id])
    @applicant = Applicant.current.find_by_id(params[:applicant_id])

    if @seminar and @applicant
      if params[:attended] == '1'
        @applicant.add_seminar(@seminar)
      else
        @applicant.remove_seminar(@seminar)
      end
    else
      head :ok
    end
  end

  # GET /seminars
  def index
    @order = scrub_order(Seminar, params[:order], 'seminars.presentation_date DESC')
    @seminars = current_user.all_viewable_seminars.order(@order).page(params[:page]).per(40)
  end

  # GET /seminars/1
  def show
  end

  # GET /seminars/new
  def new
    @seminar = current_user.seminars.new
  end

  # GET /seminars/1/edit
  def edit
  end

  # POST /seminars
  def create
    @seminar = current_user.seminars.new(seminar_params)
    if @seminar.save
      redirect_to @seminar, notice: 'Seminar was successfully created.'
    else
      render :new
    end
  end

  # PATCH /seminars/1
  def update
    if @seminar.update(seminar_params)
      redirect_to @seminar, notice: 'Seminar was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /seminars/1
  def destroy
    @seminar.destroy
    redirect_to seminars_path
  end

  private

  def set_viewable_seminar
    @seminar = current_user.all_viewable_seminars.find_by_id(params[:id])
  end

  def set_editable_seminar
    @seminar = current_user.all_seminars.find_by_id(params[:id])
  end

  def redirect_without_seminar
    empty_response_or_root_path(seminars_path) unless @seminar
  end

  def seminar_params
    params[:seminar] ||= {}

    params[:seminar][:presentation_date] = parse_date(params[:seminar][:presentation_date])

    begin
      t = Time.parse(params[:seminar][:presentation_time])
      params[:seminar][:presentation_date] = Time.parse(params[:seminar][:presentation_date].strftime('%Y-%m-%d ') + params[:seminar][:presentation_time])
    rescue
      # Do nothing
    end

    params.require(:seminar).permit(
      :category, :presenter, :presentation_title, :presentation_date, :duration, :duration_units
    )
  end

  def generate_csv(applicants, year, seminars)
    @csv_string = CSV.generate do |csv|
      category_header_row = ['']
      header_row = ['']

      @seminars.group_by(&:category).each do |category, category_seminars|
        category_seminars.sort_by(&:presentation_date).each_with_index do |seminar, index|
          category_header_row << (index == 0 ? category : '')
          header_row << seminar.presentation_date.to_date
        end
      end

      csv << category_header_row
      csv << header_row

      applicants.each do |a|
        row = [a.reverse_name]
        @seminars.group_by(&:category).each do |_category, category_seminars|
          category_seminars.sort_by(&:presentation_date).each do |seminar|
            row << (a.seminars.where(id: seminar.id).count == 1 ? 'X' : '')
          end
        end

        csv << row
      end

      csv << ['']

      @seminars.group_by(&:category).each do |category, category_seminars|
        csv << ['']
        csv << [category]
        category_seminars.sort_by(&:presentation_date).each do |seminar|
          csv << [seminar.presenter, seminar.presentation_date_with_time, seminar.presentation_title]
        end
      end
    end

    send_data @csv_string, type: 'text/csv; charset=iso-8859-1; header=present',
                           disposition: "attachment; filename=\"Training Grant Attendance #{Time.zone.now.strftime("%Y.%m.%d %Ih%M %p")}.csv\""
  end
end
