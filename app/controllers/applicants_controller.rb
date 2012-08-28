class ApplicantsController < ApplicationController
  before_filter :authenticate_user!, except: [:dashboard, :edit_me, :update_me, :exit_interview, :update_exit_interview, :add_degree]
  before_filter :check_administrator, except: [:dashboard, :edit_me, :update_me, :exit_interview, :update_exit_interview, :add_degree]

  before_filter :authenticate_applicant!, only: [:dashboard, :edit_me, :update_me, :exit_interview, :update_exit_interview]

  def add_degree

  end

  def dashboard

  end

  def edit_me
    redirect_to dashboard_applicants_path, notice: 'You have already submitted your application.' unless current_applicant.submitted_at.blank?
  end

  def update_me
    respond_to do |format|
      if current_applicant.update_attributes(post_params)
        format.html { redirect_to dashboard_applicants_path, notice: 'Application successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit_me" }
        format.json { render json: current_applicant.errors, status: :unprocessable_entity }
      end
    end
  end

  def exit_interview
    redirect_to dashboard_applicants_path, notice: 'Only enrolled applicants may fill out an exit interview.' unless current_applicant.enrolled?
  end

  def update_exit_interview
    respond_to do |format|
      if current_applicant.update_attributes(post_params)
        format.html { redirect_to dashboard_applicants_path, notice: 'Exit Interview successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "exit_interview" }
        format.json { render json: current_applicant.errors, status: :unprocessable_entity }
      end
    end
  end

  # Removes the applicants submitted_at date.  However the original submitted date will always be maintained.
  def unlock
    @applicant = Applicant.find_by_id(params[:id])
    @applicant.update_column :submitted_at, nil
    redirect_to @applicant, notice: 'Applicant has been unlocked.'
  end

  # Sends email to applicant containg authentication token
  def email
    @applicant = Applicant.find_by_id(params[:id])
    @applicant.update_general_information_email!(current_user)
    redirect_to @applicant, notice: 'Applicant has been notified by email to update application information.'
  end

  def annual_email
    @applicant = Applicant.find_by_id(params[:id])
    if @applicant
      @applicant.send_annual_reminder!(current_user, params[:annual_year].to_i, params[:annual_subject], params[:annual_body])
    else
      render nothing: true
    end
  end

  def termination_email
    @applicant = Applicant.find_by_id(params[:id])
    if @applicant
      @applicant.send_termination!(current_user)
      redirect_to @applicant, notice: 'Applicant has been notified by email to complete exit interview.'
    else
      redirect_to applicants_path
    end
  end

  def update_submitted_at_date
    @applicant = Applicant.find_by_id(params[:id])
    if @applicant
      submitted_at = parse_date(params[:submission_date], nil).at_midnight rescue nil
      @applicant.update_column :originally_submitted_at, submitted_at
      @applicant.update_column            :submitted_at, submitted_at
    else
      render nothing: true
    end
  end

  def index
    # current_user.update_column :applicants_per_page, params[:applicants_per_page].to_i if params[:applicants_per_page].to_i >= 10 and params[:applicants_per_page].to_i <= 200
    applicant_scope = Applicant.current # current_user.all_viewable_applicants

    params[:enrolled] = 'all' unless ['all', 'only', 'except'].include?(params[:enrolled])

    case params[:enrolled] when 'only'
      applicant_scope = applicant_scope.where(enrolled: true)
    when 'except'
      applicant_scope = applicant_scope.where(enrolled: false)
    end

    @search_terms = params[:search].to_s.gsub(/[^0-9a-zA-Z]/, ' ').split(' ')
    @search_terms.each{|search_term| applicant_scope = applicant_scope.search(search_term) }

    @order = scrub_order(Applicant, params[:order], 'applicants.last_name')
    applicant_scope = applicant_scope.order(@order)

    @applicant_count = applicant_scope.count

    if params[:format] == 'csv'
      if @applicant_count == 0
        redirect_to applicants_path, alert: 'No data was exported since no applicants matched the specified filters.'
        return
      end
      generate_csv(applicant_scope)
      return
    end

    @applicants = applicant_scope.page(params[:page]).per( 40 ) #current_user.applicants_per_page)

    if params[:annual_email] == '1' and params[:annual_year].to_i > 2000
      applicant_scope.each do |applicant|
        applicant.send_annual_reminder!(current_user, params[:annual_year].to_i, params[:annual_subject], params[:annual_body])
      end
    end
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

  def edit_application

  end

  # GET /applicants/1/edit
  def edit
    @applicant = Applicant.find(params[:id])
  end

  # POST /applicants
  # POST /applicants.json
  def create
    @applicant = Applicant.new(post_params)

    @applicant.skip_confirmation!

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
    @applicant = Applicant.find_by_id(params[:id])

    @applicant.skip_reconfirmation! if @applicant

    respond_to do |format|
      if @applicant
        if @applicant.update_attributes(post_params)
          format.html { redirect_to @applicant, notice: 'Applicant was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @applicant.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to applicants_path }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /applicants/1
  # DELETE /applicants/1.json
  def destroy
    @applicant = Applicant.find_by_id(params[:id])
    @applicant.destroy if @applicant

    respond_to do |format|
      format.html { redirect_to applicants_path }
      format.json { head :no_content }
    end
  end

  private

  def post_params
    params[:applicant] ||= {}
    [:desired_start_date, :review_date, :training_period_start_date, :training_period_end_date].each do |date|
      params[:applicant][date] = parse_date(params[:applicant][date]) unless params[:applicant][date] == nil
    end

    params[:applicant][:degrees_earned] ||= [] if params[:set_degrees_earned] == '1'
    params[:applicant][:research_interests] ||= [] if params[:set_research_interests] == '1'
    params[:applicant][:urm_types] ||= [] if params[:set_urm_types] == '1'
    params[:applicant][:laboratories] ||= [] if params[:set_laboratories] == '1'
    params[:applicant][:transition_position] ||= [] if params[:set_transition_position] == '1'

    if current_user and current_user.administrator?
      params[:applicant]
    else
      params[:applicant].slice(
        # Applicant Information
        :email, :first_name, :last_name, :middle_initial, :applicant_type, :citizenship_status, :alien_registration_number, :desired_start_date, :personal_statement,
        # Contact Information
        :phone, :address1, :address2, :city, :state, :country, :zip_code,
        # Uploaded Curriculum Vitae
        :curriculum_vitae, :curriculum_vitae_uploaded_at, :curriculum_vitae_cache,
        # Education
        :current_institution, :department_program, :current_position, :degrees_earned,
        :degree_sought, :expected_year, :residency, :research_interests, :research_interests_other,
        :preferred_preceptor_id, :preferred_preceptor_two_id, :preferred_preceptor_three_id,
        :previous_nrsa_support,
        # Demographic Information
        :gender, :disabled, :disabled_description, :disadvantaged, :urm, :urm_types, :marital_status,
        # Applicant Assurance
        :assurance, :publish, :letters_from_a, :letters_from_b, :letters_from_c,
        # Termination
        :publish_termination,
        :future_email, :entrance_year, :t32_funded, :t32_funded_years, :academic_program_completed,
        :research_project_title, :laboratories, :immediate_transition,
        :transition_position, :transition_position_other, :termination_feedback,
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
        'Current Institution', 'CV', 'Degree Sought', 'Department/Program', 'Expected Year', 'Research Interests', 'Research Interests Other',
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
        # Automatically Updated Fields
        'Submitted At', 'Resubmitted At',
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
          a.current_institution, a.cv, a.degree_sought, a.department_program, a.expected_year, a.research_interests, a.research_interests_other,
          a.preferred_preceptor ? a.preferred_preceptor.name_with_id : '',
          a.preferred_preceptor ? a.preferred_preceptor.hospital_affiliation : '',
          a.preferred_preceptor_two ? a.preferred_preceptor_two.name_with_id : '',
          a.preferred_preceptor_three ? a.preferred_preceptor_three.name_with_id : '',
          a.degrees_earned_text, a.current_position, a.previous_nrsa_support,
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
          # Automatically Updated Fields
          a.originally_submitted_at, a.submitted_at,
          # Termination
          a.future_email, a.entrance_year, a.t32_funded, a.t32_funded_years, a.academic_program_completed,
          a.research_project_title, a.laboratories, a.immediate_transition,
          a.transition_position, a.transition_position_other, a.termination_feedback
        ]
        csv << row
      end
    end

    send_data @csv_string, type: 'text/csv; charset=iso-8859-1; header=present',
                           disposition: "attachment; filename=\"Training Grant Applicants and Trainees #{Time.now.strftime("%Y.%m.%d %Ih%M %p")}.csv\""
  end

end
