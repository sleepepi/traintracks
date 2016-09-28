# frozen_string_literal: true

# Tracks annual information for trainees.
class AnnualsController < ApplicationController
  before_action :authenticate_applicant_from_token!, only: [:edit_me, :update_me]
  before_action :authenticate_user!, except: [:edit_me, :update_me]
  before_action :check_administrator, except: [:edit_me, :update_me]
  before_action :authenticate_applicant!, only: [:edit_me, :update_me]
  before_action :set_viewable_annual, only: [:show]
  before_action :set_editable_annual, only: [:edit, :update, :destroy]
  before_action :redirect_without_annual, only: [:show, :edit, :update, :destroy]

  # GET /annuals
  def index
    @order = scrub_order(Annual, params[:order], 'annuals.id')
    annual_scope = current_user.all_viewable_annuals.search(params[:search]).order(@order)
    annual_scope = annual_scope.where(year: params[:year]) unless params[:year].blank?

    if params[:format] == 'csv'
      if annual_scope.count == 0
        redirect_to annuals_path, alert: 'No data was exported since no applicants matched the specified filters.'
        return
      end
      generate_csv(annual_scope)
      return
    end

    @annuals = annual_scope.page(params[:page]).per(40)
  end

  # GET /annuals/1
  def show
  end

  # GET /annuals/new
  def new
    @annual = current_user.annuals.new
  end

  # GET /annuals/1/edit
  def edit
  end

  # GET /annuals/1/edit_me
  def edit_me
    @annual = current_applicant.annuals.find_by_id(params[:id])
    redirect_to dashboard_applicants_path unless @annual
  end

  # POST /annuals
  def create
    @annual = current_user.annuals.new(annual_params)

    if @annual.save
      redirect_to @annual, notice: 'Annual was successfully created.'
    else
      render :new
    end
  end

  # PATCH /annuals/1
  def update
    if @annual.update(annual_params)
      redirect_to @annual, notice: 'Annual was successfully updated.'
    else
      render :edit
    end
  end

  def update_me
    @annual = current_applicant.annuals.find_by_id(params[:id])

    if @annual
      if current_applicant.update(applicant_params) && @annual.update(annual_params)
        @annual.send_annual_submitted_in_background!
        redirect_to dashboard_applicants_path, notice: 'Annual information was successfully updated.'
      else
        render :edit_me
      end
    else
      redirect_to dashboard_applicants_path
    end
  end

  # DELETE /annuals/1
  def destroy
    @annual.destroy
    redirect_to annuals_path
  end

  private

  def set_viewable_annual
    @annual = current_user.all_viewable_annuals.find_by_id(params[:id])
  end

  def set_editable_annual
    @annual = current_user.all_annuals.find_by_id(params[:id])
  end

  def redirect_without_annual
    empty_response_or_root_path(annuals_path) unless @annual
  end

  def annual_params
    if current_user
      params.require(:annual).permit(
        # Admin Only
        :applicant_id, :year,
        # General Annual
        :coursework_completed, :publications, :presentations,
        :research_description, :degree_or_certifications_earned,
        :source_of_support,
        # NIH File Upload
        :nih_other_support, :nih_other_support_cache,
        :nih_other_support_uploaded_at
      )
    else # Current Applicant
      params.require(:annual).permit(
        # General Annual
        :coursework_completed, :publications, :presentations,
        :research_description, :degree_or_certifications_earned,
        :source_of_support,
        # NIH File Upload
        :nih_other_support, :nih_other_support_cache,
        :nih_other_support_uploaded_at,
        # Publish
        :publish
      )
    end
  end

  def applicant_params
    params[:applicant] ||= {}
    params[:applicant][:degree_hashes] ||= [] if params[:set_degree_hashes] == '1'
    params.require(:applicant).permit(
      # Contact Information
      :phone, :address1, :address2, :city, :state, :country, :zip_code,
      # Uploaded Curriculum Vitae
      :curriculum_vitae, :curriculum_vitae_uploaded_at, :curriculum_vitae_cache,
      # Education
      :current_institution, :department_program, :current_position,
      { degree_hashes: [:degree_type, :institution, :year, :advisor, :thesis, :concentration_major] },
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
        'Year', 'Coursework Completed', 'Publications',
        'Conferences, Presentations, Honors, and Fellowships',
        'Research Description',
        'Degree or Certifications earned (Year) or Other Relevant Outcome',
        'Source of Support'
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
          a.degree_or_certifications_earned,
          a.source_of_support
        ]
        csv << row
      end
    end

    send_data @csv_string, type: 'text/csv; charset=iso-8859-1; header=present',
                           disposition: "attachment; filename=\"Training Grant Annual Information #{Time.zone.now.strftime("%Y.%m.%d %Ih%M %p")}.csv\""
  end
end
