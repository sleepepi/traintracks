class SeminarsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_administrator

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
    seminar_scope = current_user.all_viewable_seminars
    @order = scrub_order(Seminar, params[:order], "seminars.presentation_date")
    seminar_scope = seminar_scope.order(@order)
    @seminar_count = seminar_scope.count
    @seminars = seminar_scope.page(params[:page]).per( 20 )

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @seminars }
    end
  end

  # GET /seminars/1
  # GET /seminars/1.json
  def show
    @seminar = current_user.all_viewable_seminars.find_by_id(params[:id])

    respond_to do |format|
      if @seminar
        format.html # show.html.erb
        format.json { render json: @seminar }
      else
        format.html { redirect_to seminars_path }
        format.json { head :no_content }
      end
    end
  end

  # GET /seminars/new
  # GET /seminars/new.json
  def new
    @seminar = current_user.seminars.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @seminar }
    end
  end

  # GET /seminars/1/edit
  def edit
    @seminar = current_user.all_seminars.find_by_id(params[:id])
    redirect_to seminars_path unless @seminar
  end

  # POST /seminars
  # POST /seminars.json
  def create
    @seminar = current_user.seminars.new(post_params)

    respond_to do |format|
      if @seminar.save
        format.html { redirect_to @seminar, notice: 'Seminar was successfully created.' }
        format.json { render json: @seminar, status: :created, location: @seminar }
      else
        format.html { render action: "new" }
        format.json { render json: @seminar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /seminars/1
  # PUT /seminars/1.json
  def update
    @seminar = current_user.all_seminars.find_by_id(params[:id])

    respond_to do |format|
      if @seminar
        if @seminar.update_attributes(post_params)
          format.html { redirect_to @seminar, notice: 'Seminar was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @seminar.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to seminars_path }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /seminars/1
  # DELETE /seminars/1.json
  def destroy
    @seminar = current_user.all_seminars.find_by_id(params[:id])
    @seminar.destroy if @seminar

    respond_to do |format|
      format.html { redirect_to seminars_path }
      format.json { head :no_content }
    end
  end

  private

  def post_params
    params[:seminar] ||= {}

    params[:seminar][:presentation_date] = parse_date(params[:seminar][:presentation_date])

    begin
      t = Time.parse(params[:seminar][:presentation_time])
      params[:seminar][:presentation_date] = Time.parse(params[:seminar][:presentation_date].strftime("%Y-%m-%d ") + params[:seminar][:presentation_time])
    rescue
      # Do nothing
    end

    params[:seminar].slice(
      :category, :presenter, :presentation_title, :presentation_date, :duration, :duration_units
    )
  end

end
