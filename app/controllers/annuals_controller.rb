class AnnualsController < ApplicationController
  before_filter :authenticate_user!, except: [:edit_me, :update_me]
  before_filter :check_administrator, except: [:edit_me, :update_me]

  before_filter :authenticate_applicant!, only: [:edit_me, :update_me]

  # GET /annuals
  # GET /annuals.json
  def index
    annual_scope = current_user.all_viewable_annuals

    @search_terms = params[:search].to_s.gsub(/[^0-9a-zA-Z]/, ' ').split(' ')
    @search_terms.each{|search_term| annual_scope = annual_scope.search(search_term) }

    annual_scope = annual_scope.where(year: params[:year]) unless params[:year].blank?

    @order = scrub_order(Annual, params[:order], "annuals.id")
    annual_scope = annual_scope.order(@order)
    @annual_count = annual_scope.count

    if params[:format] == 'csv'
      if @annual_count == 0
        redirect_to annuals_path, alert: 'No data was exported since no applicants matched the specified filters.'
        return
      end
      generate_csv(annual_scope)
      return
    end

    @annuals = annual_scope.page(params[:page]).per( 20 )

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @annuals }
    end
  end

  # GET /annuals/1
  # GET /annuals/1.json
  def show
    @annual = current_user.all_viewable_annuals.find_by_id(params[:id])

    respond_to do |format|
      if @annual
        format.html # show.html.erb
        format.json { render json: @annual }
      else
        format.html { redirect_to annuals_path }
        format.json { head :no_content }
      end
    end
  end

  # GET /annuals/new
  # GET /annuals/new.json
  def new
    @annual = current_user.annuals.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @annual }
    end
  end

  # GET /annuals/1/edit
  def edit
    @annual = current_user.all_annuals.find_by_id(params[:id])
    redirect_to annuals_path unless @annual
  end

  def edit_me
    @annual = current_applicant.annuals.find_by_id(params[:id])
    redirect_to dashboard_applicants_path unless @annual
  end

  # POST /annuals
  # POST /annuals.json
  def create
    @annual = current_user.annuals.new(post_params)

    respond_to do |format|
      if @annual.save
        format.html { redirect_to @annual, notice: 'Annual was successfully created.' }
        format.json { render json: @annual, status: :created, location: @annual }
      else
        format.html { render action: "new" }
        format.json { render json: @annual.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /annuals/1
  # PUT /annuals/1.json
  def update
    @annual = current_user.all_annuals.find_by_id(params[:id])

    respond_to do |format|
      if @annual
        if @annual.update_attributes(post_params)
          format.html { redirect_to @annual, notice: 'Annual was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @annual.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to annuals_path }
        format.json { head :no_content }
      end
    end
  end

  def update_me
    @annual = current_applicant.annuals.find_by_id(params[:id])

    respond_to do |format|
      if @annual
        if current_applicant.update_attributes(post_params_applicant) and @annual.update_attributes(post_params)
          format.html { redirect_to dashboard_applicants_path, notice: 'Annual information was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit_me" }
          format.json { render json: @annual.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to dashboard_applicants_path }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /annuals/1
  # DELETE /annuals/1.json
  def destroy
    @annual = current_user.all_annuals.find_by_id(params[:id])
    @annual.destroy if @annual

    respond_to do |format|
      format.html { redirect_to annuals_path }
      format.json { head :no_content }
    end
  end

  private

  def post_params
    params[:annual] ||= {}

    if current_user
      params[:annual].slice(
        # Admin Only
        :applicant_id, :year,
        # General Annual
        :coursework_completed, :publications, :presentations, :research_description, :source_of_support,
        # NIH File Upload
        :nih_other_support, :nih_other_support_cache, :nih_other_support_uploaded_at
      )
    else # Current Applicant
      params[:annual].slice(
        # General Annual
        :coursework_completed, :publications, :presentations, :research_description, :source_of_support,
        # NIH File Upload
        :nih_other_support, :nih_other_support_cache, :nih_other_support_uploaded_at,
        # Publish
        :publish
      )
    end

    params[:annual]
  end

  def post_params_applicant
    params[:applicant] ||= {}

    params[:applicant][:degrees_earned] ||= [] if params[:set_degrees_earned] == '1'

    params[:applicant].slice(
      # Contact Information
      :phone, :address1, :address2, :city, :state, :country, :zip_code,
      # Uploaded Curriculum Vitae
      :curriculum_vitae, :curriculum_vitae_uploaded_at, :curriculum_vitae_cache,
      # Education
      :current_institution, :department_program, :current_position, :degrees_earned,
      # Applicant Assurance
      :publish_annual
    )
  end

  def generate_csv(annual_scope)
    @csv_string = CSV.generate do |csv|
      csv << [
        'Applicant ID',
        # Applicant Information
        'Email', 'Last Name', 'First Name',
        # Annual Information
        'Year', 'Coursework Completed', 'Publications', 'Conferences, Presentations, Honors, and Fellowships', 'Research Description', 'Source of Support'
      ]

      annual_scope.each do |a|
        row = [
          a.applicant_id,
          a.applicant ? a.applicant.email : '',
          a.applicant ? a.applicant.last_name : '',
          a.applicant ? a.applicant.first_name : '',
          a.year,
          a.coursework_completed,
          a.publications,
          a.presentations,
          a.research_description,
          a.source_of_support
        ]
        csv << row
      end
    end

    send_data @csv_string, type: 'text/csv; charset=iso-8859-1; header=present',
                           disposition: "attachment; filename=\"Training Grant Annual Information #{Time.now.strftime("%Y.%m.%d %Ih%M %p")}.csv\""
  end

end
