class SeminarsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_administrator
  before_action :set_viewable_seminar, only: [ :show ]
  before_action :set_editable_seminar, only: [ :edit, :update, :destroy ]
  before_action :redirect_without_seminar, only: [ :show, :edit, :update, :destroy ]


  def attendance
    @applicants = Applicant.current.where(enrolled: true).where(status: (params[:status].blank? ? Applicant::STATUS.flatten.uniq : params[:status]))
    @year = params[:year].blank? ? (Date.today.month > 6 ? Date.today.year + 1 : Date.today.year) : params[:year].to_i
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
      render nothing: true
    end
  end

  # GET /seminars
  # GET /seminars.json
  def index
    @order = scrub_order(Seminar, params[:order], "seminars.presentation_date DESC")
    @seminars = current_user.all_viewable_seminars.order(@order).page(params[:page]).per( 40 )
  end

  # GET /seminars/1
  # GET /seminars/1.json
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
  # POST /seminars.json
  def create
    @seminar = current_user.seminars.new(seminar_params)

    respond_to do |format|
      if @seminar.save
        format.html { redirect_to @seminar, notice: 'Seminar was successfully created.' }
        format.json { render action: 'show', status: :created, location: @seminar }
      else
        format.html { render action: 'new' }
        format.json { render json: @seminar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /seminars/1
  # PUT /seminars/1.json
  def update
    respond_to do |format|
      if @seminar.update(seminar_params)
        format.html { redirect_to @seminar, notice: 'Seminar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @seminar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seminars/1
  # DELETE /seminars/1.json
  def destroy
    @seminar.destroy

    respond_to do |format|
      format.html { redirect_to seminars_path }
      format.json { head :no_content }
    end
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
        params[:seminar][:presentation_date] = Time.parse(params[:seminar][:presentation_date].strftime("%Y-%m-%d ") + params[:seminar][:presentation_time])
      rescue
        # Do nothing
      end

      params.require(:seminar).permit(
        :category, :presenter, :presentation_title, :presentation_date, :duration, :duration_units
      )
    end

    def generate_csv(applicants, year, seminars)
      @csv_string = CSV.generate do |csv|
        category_header_row = [""]
        header_row = [""]

        @seminars.group_by{|s| s.category}.each do |category, seminars|
          seminars.sort_by{ |s| s.presentation_date }.each_with_index do |seminar, index|
            category_header_row << (index == 0 ? category : "")
            header_row << seminar.presentation_date.to_date
          end
        end

        csv << category_header_row
        csv << header_row

        applicants.each do |a|
          row = [ a.reverse_name ]
          @seminars.group_by{|s| s.category}.each do |category, seminars|
            seminars.sort_by{ |s| s.presentation_date }.each do |seminar|
              row << (a.seminars.where(id: seminar.id).count == 1 ? "X" : "")
            end
          end

          csv << row
        end

        csv << [""]

        @seminars.group_by{|s| s.category}.each do |category, seminars|
          csv << [""]
          csv << [category]
          seminars.sort_by{ |s| s.presentation_date }.each do |seminar|
            csv << [seminar.presenter, seminar.presentation_date_with_time, seminar.presentation_title]
          end
        end
      end

      send_data @csv_string, type: 'text/csv; charset=iso-8859-1; header=present',
                             disposition: "attachment; filename=\"Training Grant Attendance #{Time.zone.now.strftime("%Y.%m.%d %Ih%M %p")}.csv\""
    end

end
