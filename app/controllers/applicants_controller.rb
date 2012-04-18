class ApplicantsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_administrator

  def index
    # current_user.update_attribute :applicants_per_page, params[:applicants_per_page].to_i if params[:applicants_per_page].to_i >= 10 and params[:applicants_per_page].to_i <= 200
    applicant_scope = Applicant.current # current_user.all_viewable_applicants
    @search_terms = params[:search].to_s.gsub(/[^0-9a-zA-Z]/, ' ').split(' ')
    @search_terms.each{|search_term| applicant_scope = applicant_scope.search(search_term) }

    @order = Applicant.column_names.collect{|column_name| "applicants.#{column_name}"}.include?(params[:order].to_s.split(' ').first) ? params[:order] : "applicants.last_name"
    applicant_scope = applicant_scope.order(@order)

    @applicants = applicant_scope.page(params[:page]).per( 40 ) #current_user.applicants_per_page)
  end

  # GET /applicants/1
  # GET /applicants/1.json
  def show
    @applicant = Applicant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @applicant }
    end
  end

  # GET /applicants/new
  # GET /applicants/new.json
  def new
    @applicant = Applicant.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @applicant }
    end
  end

  # GET /applicants/1/edit
  def edit
    @applicant = Applicant.find(params[:id])
  end

  # POST /applicants
  # POST /applicants.json
  def create
    params[:applicant][:desired_start_date] = Date.strptime(params[:applicant][:desired_start_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:desired_start_date].blank?
    params[:applicant][:review_date] = Date.strptime(params[:applicant][:review_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:review_date].blank?
    params[:applicant][:training_period_start_date] = Date.strptime(params[:applicant][:training_period_start_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:training_period_start_date].blank?
    params[:applicant][:training_period_end_date] = Date.strptime(params[:applicant][:training_period_end_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:training_period_end_date].blank?

    @applicant = Applicant.new(params[:applicant])

    respond_to do |format|
      if @applicant.save
        format.html { redirect_to @applicant, notice: 'Applicant was successfully created.' }
        format.json { render json: @applicant, status: :created, location: @applicant }
      else
        format.html { render action: "new" }
        format.json { render json: @applicant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /applicants/1
  # PUT /applicants/1.json
  def update
    params[:applicant][:desired_start_date] = Date.strptime(params[:applicant][:desired_start_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:desired_start_date].blank?
    params[:applicant][:review_date] = Date.strptime(params[:applicant][:review_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:review_date].blank?
    params[:applicant][:training_period_start_date] = Date.strptime(params[:applicant][:training_period_start_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:training_period_start_date].blank?
    params[:applicant][:training_period_end_date] = Date.strptime(params[:applicant][:training_period_end_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:training_period_end_date].blank?

    @applicant = Applicant.find(params[:id])

    respond_to do |format|
      if @applicant.update_attributes(params[:applicant])
        format.html { redirect_to @applicant, notice: 'Applicant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @applicant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applicants/1
  # DELETE /applicants/1.json
  def destroy
    @applicant = Applicant.find(params[:id])
    @applicant.destroy

    respond_to do |format|
      format.html { redirect_to applicants_url }
      format.json { head :no_content }
    end
  end

  private

  def post_params
    if current_user.administrator?
      params[:applicant]
    else
      params[:applicant].slice(
        # Applicant Information
        :email, :first_name, :last_name, :middle_initial, :applicant_type, :summer, :tge, :desired_start_date,
        # Education
        :advisor, :concentration_major, :current_institution, :cv, :degree_sought, :department_program, :expected_year,
        :preferred_preceptor_id, :previous_institutions, :thesis, :degrees, :current_title,
        # Demographic Information
        :disabled, :disadvantaged, :urm, :marital_status,
        # Contact Information
        :phone, :address1, :address2, :city, :state, :country, :zip_code,
        # Postdoc Only
        :residency,
        # Trainee Only
        :research_project_title,
        # Annual Only
        :coursework_completed, :pubs_not_prev_rep, :presentations, :research_description, :source_of_support,
        # Applicant Assurance
        :assurance
       )
    end
  end
end
