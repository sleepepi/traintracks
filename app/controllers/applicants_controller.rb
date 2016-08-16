# frozen_string_literal: true

# Allows applicants to edit profile information.
class ApplicantsController < ApplicationController
  before_action :authenticate_applicant_from_token!, only: [:dashboard, :edit_me, :update_me, :exit_interview, :update_exit_interview, :help_email]
  before_action :authenticate_user!, except: [:dashboard, :edit_me, :update_me, :exit_interview, :update_exit_interview, :add_degree, :help_email]
  before_action :check_administrator, except: [:dashboard, :edit_me, :update_me, :exit_interview, :update_exit_interview, :add_degree, :help_email]
  before_action :authenticate_applicant!, only: [:dashboard, :edit_me, :update_me, :exit_interview, :update_exit_interview, :help_email]
  before_action :set_applicant, only: [:show, :edit, :update, :destroy, :email, :annual_email, :termination_email, :unlock, :update_submitted_at_date]
  before_action :redirect_without_applicant, only: [:show, :edit, :update, :destroy, :email, :annual_email, :termination_email, :unlock, :update_submitted_at_date]

  def help_email
    UserMailer.help_email(current_applicant, params[:subject], params[:body]).deliver_now if EMAILS_ENABLED
  end

  def add_degree
    @degree = Degree.new
  end

  def dashboard
  end

  def edit_me
    redirect_to dashboard_applicants_path, notice: 'You have already submitted your application.' unless current_applicant.submitted_at.blank?
  end

  def update_me
    if current_applicant.update(applicant_params)
      redirect_to dashboard_applicants_path, notice: 'Application successfully updated.'
    else
      render :edit_me
    end
  end

  def exit_interview
    redirect_to dashboard_applicants_path, notice: 'Only enrolled applicants may fill out an exit interview.' unless current_applicant.enrolled?
  end

  def update_exit_interview
    if current_applicant.update(applicant_params)
      redirect_to dashboard_applicants_path, notice: 'Exit Interview successfully updated.'
    else
      render :exit_interview
    end
  end

  # Removes the applicants submitted_at date.  However the original submitted date will always be maintained.
  def unlock
    @applicant.update_column :submitted_at, nil
    redirect_to @applicant, notice: 'Applicant has been unlocked.'
  end

  # Sends email to applicant containg authentication token
  def email
    @applicant.update_general_information_email!(current_user)
    redirect_to @applicant, notice: 'Applicant has been notified by email to update application information.'
  end

  def annual_email
    @applicant.send_annual_reminder!(current_user, params[:annual_year].to_i, params[:annual_subject], params[:annual_body])
  end

  def termination_email
    @applicant.send_termination!(current_user)
    redirect_to @applicant, notice: 'Applicant has been notified by email to complete exit interview.'
  end

  def update_submitted_at_date
    submitted_at = parse_date(params[:submission_date], nil).at_midnight rescue nil
    @applicant.update_column :originally_submitted_at, submitted_at
    @applicant.update_column            :submitted_at, submitted_at
  end

  def send_annual_reminder_email
    if params[:applicant_id].blank?
      applicant_scope = Applicant.supported_by_tg_in_last_fifteen_years
      notice = "Annual Reminder email successfully sent to #{applicant_scope.count} applicants."
    else
      applicant_scope = Applicant.current.where( id: params[:applicant_id] )
      notice = (applicant_scope.first ? "Annual Reminder email successfully sent to #{applicant_scope.first.name}." : 'No valid applicant selected.')
    end

    if params[:year].to_i > 2000
      applicant_scope.each do |applicant|
        applicant.send_annual_reminder!(current_user, params[:year].to_i, params[:subject], params[:body])
      end
      redirect_to (applicant_scope.count == 1 ? applicant_scope.first : applicants_path), notice: notice
    else
      redirect_to applicants_path, alert: "'#{params[:year].to_i}' is not a valid year."
    end
  end

  def index
    @order = scrub_order(Applicant, params[:order], 'applicants.last_name')
    applicant_scope = Applicant.current.search(params[:search]).order(@order)

    params[:enrolled] = 'all' unless ['all', 'only', 'except'].include?(params[:enrolled])

    case params[:enrolled] when 'only'
      applicant_scope = applicant_scope.where(enrolled: true)
    when 'except'
      applicant_scope = applicant_scope.where(enrolled: false)
    end

    if params[:format] == 'csv'
      if applicant_scope.count == 0
        redirect_to applicants_path, alert: 'No data was exported since no applicants matched the specified filters.'
        return
      end
      generate_csv(applicant_scope)
      return
    end

    @applicants = applicant_scope.page(params[:page]).per( 40 )
  end

  def program_requirements
    @order = scrub_order(Applicant, params[:order], 'applicants.last_name')

    applicant_scope = Applicant.current_trainee.search(params[:search]).order(@order)

    if params[:format] == 'csv'
      if applicant_scope.count == 0
        redirect_to program_requirements_applicants_path(search: params[:search]), alert: 'No data was exported since no applicants matched the specified filters.'
        return
      end
      generate_program_requirements_csv(applicant_scope)
      return
    end

    @applicants = applicant_scope.page(params[:page]).per( 40 )
  end

  # GET /applicants/1
  def show
  end

  # GET /applicants/new
  def new
    @applicant = Applicant.new
  end

  # GET /applicants/1/edit
  def edit
  end

  # POST /applicants
  def create
    @applicant = Applicant.new(applicant_params)
    @applicant.skip_confirmation!
    if @applicant.save
      redirect_to @applicant, notice: 'Applicant was successfully created.'
    else
      render :new
    end
  end

  # PATCH /applicants/1
  def update
    @applicant.skip_reconfirmation!
    if @applicant.update(applicant_params)
      redirect_to @applicant, notice: 'Applicant was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /applicants/1
  def destroy
    @applicant.destroy
    redirect_to applicants_path
  end

  private

  def set_applicant
    @applicant = Applicant.find_by_id(params[:id])
  end

  def redirect_without_applicant
    empty_response_or_root_path(applicants_path) unless @applicant
  end

  def applicant_params
    params[:applicant] ||= {}

    general_dates = [:desired_start_date, :review_date, :training_period_start_date, :training_period_end_date, :most_recent_curriculum_advisor_meeting_date]
    program_requirement_dates = [ :research_in_progress_date, :research_ethics_training_completed_date, :grant_writing_training_completed_date, :basic_research_statistics_course_completed_date, :advanced_research_statistics_course_completed_date, :neuroscience_course_completed_date, :hsoph_summer_session_course_completed_date, :individual_funding_submission_date, :last_idp_date ]

    (general_dates + program_requirement_dates).each do |date|
      params[:applicant][date] = parse_date(params[:applicant][date]) unless params[:applicant][date] == nil
    end

    params[:applicant][:degree_hashes] ||= [] if params[:set_degree_hashes] == '1'
    params[:applicant][:research_interests] ||= [] if params[:set_research_interests] == '1'
    params[:applicant][:urm_types] ||= [] if params[:set_urm_types] == '1'
    params[:applicant][:laboratories] ||= [] if params[:set_laboratories] == '1'
    params[:applicant][:transition_position] ||= [] if params[:set_transition_position] == '1'

    if current_user && current_user.administrator?
      params[:applicant][:admin_update] = '1'
      params.require(:applicant).permit!
    else
      params.require(:applicant).permit(
        # Applicant Information
        :email, :first_name, :last_name, :middle_initial, :applicant_type,
        :citizenship_status, :alien_registration_number, :desired_start_date,
        :personal_statement,
        # Contact Information
        :phone, :address1, :address2, :city, :state, :country, :zip_code,
        # Uploaded Curriculum Vitae
        :curriculum_vitae, :curriculum_vitae_uploaded_at, :curriculum_vitae_cache,
        # Education
        :current_institution, :department_program, :current_position,
        { degree_hashes: [:degree_type, :institution, :year, :advisor, :thesis, :concentration_major] },
        :degree_sought, :expected_year, :residency,
        [research_interests: []],
        :research_interests_other,
        :preferred_preceptor_id, :preferred_preceptor_two_id, :preferred_preceptor_three_id,
        :previous_nrsa_support,
        # Demographic Information
        :gender, :disabled, :disabled_description, :disadvantaged, :urm,
        [urm_types: []],
        :marital_status,
        # Progress Report Data
        :approved_irb_protocols,
        :approved_irb_document, :approved_irb_document_uploaded_at, :approved_irb_document_cache,
        :approved_iacuc_protocols,
        :approved_iacuc_document, :approved_iacuc_document_uploaded_at, :approved_iacuc_document_cache,
        # Applicant Assurance
        :assurance, :publish, :letters_from_a, :letters_from_b, :letters_from_c,
        # Termination
        :publish_termination,
        :future_email, :entrance_year, :t32_funded, :t32_funded_years, :academic_program_completed,
        :research_project_title,
        [laboratories: []],
        :immediate_transition,
        [transition_position: []],
        :transition_position_other, :termination_feedback,
        :certificate_application, :certificate_application_cache
       )
    end
  end

  def generate_csv(applicant_scope)
    @csv_string = CSV.generate do |csv|
      csv << [
        'Applicant ID',
        # Applicant Information
        'Email', 'Last Name', 'First Name', 'Middle Initial', 'Applicant Type', 'TGE', 'Desired Start Date', 'Personal Statement', 'Alien Registration Number', 'Citizenship Status',
        # Education
        'Current Institution', 'Degree Sought', 'Department/Program', 'Expected Year', 'Research Interests', 'Research Interests Other',
        'Preferred Preceptor ID', 'Preferred Preceptor Hospital Affiliation', 'Preferred Preceptor Two ID', 'Preferred Preceptor Three ID',
        'Degrees Earned', 'Current Position', 'Previous NRSA Support',
        # Demographic Information
        'Gender', 'Disabled', 'Disabled Description', 'Disadvantaged', 'URM', 'URM Types', 'Marital Status',
        # Contact Information
        'Phone', 'Address1', 'Address2', 'City', 'State', 'Country', 'Zip Code',
        # Postdoc Only
        'Residency',
        # Applicant Assurance
        'Assurance', 'Letters From A', 'Letters From B', 'Letters From C',
        # Administrator Only
        'Reviewed', 'Review Date', 'Offered', 'Accepted', 'Enrolled', 'CV Number', 'Degree Type', 'Primary Preceptor ID', 'Secondary Preceptor ID', 'Trainee Code',
        'Status', 'Training Grant Years', 'Supported by Training Grant', 'Training Period Start Date', 'Training Period End Date', 'Notes',
        'Curriculum Advisor', 'Most Recent Curriculum Advisor Meeting Date', 'Past Curriculum Advisor Meetings', 'eRA Commons Username',
        # Automatically Updated Fields
        'Submitted At', 'Resubmitted At',
        # Progress Report Data
        'Approved IRB Protocols', 'Approved IACUC Protocols',
        # Termination
        'Future Email', 'Entrance Year', 'T32 Funded', 'T32 Funded Years', 'Academic Program Completed',
        'Research Project Title', 'Laboratories', 'Immediate Transition',
        'Transition Position', 'Transition Position Other', 'Termination Feedback'
     ]

      applicant_scope.each do |a|
        row = [
          a.id,
          # Applicant Information
          a.email, a.last_name, a.first_name, a.middle_initial, a.applicant_type, a.tge, a.desired_start_date, a.personal_statement, a.alien_registration_number, a.citizenship_status,
          # Education
          a.current_institution, a.degree_sought, a.department_program, a.expected_year, a.research_interests, a.research_interests_other,
          a.preferred_preceptor ? a.preferred_preceptor.name_with_id : '',
          a.preferred_preceptor ? a.preferred_preceptor.hospital_affiliation : '',
          a.preferred_preceptor_two ? a.preferred_preceptor_two.name_with_id : '',
          a.preferred_preceptor_three ? a.preferred_preceptor_three.name_with_id : '',
          a.degrees_text, a.current_position, a.previous_nrsa_support,
          # Demographic Information
          a.gender, a.disabled, a.disabled_description, a.disadvantaged, a.urm, a.urm_types, a.marital_status,
          # Contact Information
          a.phone, a.address1, a.address2, a.city, a.state, a.country, a.zip_code,
          # Postdoc Only
          a.residency,
          # Applicant Assurance
          a.assurance, a.letters_from_a, a.letters_from_b, a.letters_from_c,
          # Administrator Only
          a.reviewed, a.review_date, a.offered, a.accepted, a.enrolled, a.cv_number, a.degree_type,
          a.primary_preceptor ? a.primary_preceptor.name_with_id : '',
          a.secondary_preceptor ? a.secondary_preceptor.name_with_id : '',
          a.trainee_code,
          a.status, a.training_grant_years, a.supported_by_tg, a.training_period_start_date, a.training_period_end_date, a.notes,
          a.curriculum_advisor, a.most_recent_curriculum_advisor_meeting_date, a.past_curriculum_advisor_meetings, a.era_commons_username,
          # Automatically Updated Fields
          a.originally_submitted_at, a.submitted_at,
          # Progress Report Data
          a.approved_irb_protocols, a.approved_iacuc_protocols,
          # Termination
          a.future_email, a.entrance_year, a.t32_funded, a.t32_funded_years, a.academic_program_completed,
          a.research_project_title, a.laboratories, a.immediate_transition,
          a.transition_position, a.transition_position_other, a.termination_feedback
        ]
        csv << row
      end
    end

    send_data @csv_string, type: 'text/csv; charset=iso-8859-1; header=present',
                           disposition: "attachment; filename=\"Training Grant Applicants and Trainees #{Time.zone.now.strftime("%Y.%m.%d %Ih%M %p")}.csv\""
  end

  def generate_program_requirements_csv(applicant_scope)
    @csv_string = CSV.generate do |csv|
      csv << [
        'Applicant ID',
        # Applicant Information
        'Last Name', 'First Name',
        # Program Requirements
        'Research-In-Progress Title', 'Research-In-Progress Date', 'Additional Research-In-Progress Titles and Dates',
        'Research Ethics Training Completed', 'Research Ethics Training Notes', 'Grant Writing Training Completed',
        'Basic Research Statistics Course Completed', 'Advanced Research Statistics Course Completed',
        'Neuroscience Course Completed', 'Harvard School of Public Health Summer Session Courses Completed',
        'Submitted application for Individual Funding', 'Individual Funding Type', 'Last IDP'
     ]

      applicant_scope.each do |a|
        row = [
          a.id,
          # Applicant Information
          a.last_name, a.first_name,
          a.research_in_progress_title, a.research_in_progress_date, a.research_in_progress_additional,
          a.research_ethics_training_completed_date, a.research_ethics_training_notes, a.grant_writing_training_completed_date,
          a.basic_research_statistics_course_completed_date, a.advanced_research_statistics_course_completed_date,
          a.neuroscience_course_completed_date, a.hsoph_summer_session_course_completed_date,
          a.individual_funding_submission_date, a.individual_funding_type, a.last_idp_date
        ]
        csv << row
      end
    end

    send_data @csv_string, type: 'text/csv; charset=iso-8859-1; header=present',
                           disposition: "attachment; filename=\"Training Grant Applicants and Trainees Program Requirements #{Time.zone.now.strftime("%Y.%m.%d %Ih%M %p")}.csv\""
  end
end
