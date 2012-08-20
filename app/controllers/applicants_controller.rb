class ApplicantsController < ApplicationController
  before_filter :authenticate_user!, except: [:dashboard, :edit_me, :update_me]
  before_filter :check_administrator, except: [:dashboard, :edit_me, :update_me]

  before_filter :authenticate_applicant!, only: [:dashboard, :edit_me, :update_me]

  def dashboard

  end

  def edit_me
    redirect_to dashboard_applicants_path, info: 'You have already submitted your application.' unless current_applicant.submitted_at.blank?
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

  # Removes the applicants submitted_at date.  However the original submitted date will always be maintained.
  def unlock
    @applicant = Applicant.find(params[:id])
    @applicant.update_column :submitted_at, nil
    redirect_to @applicant, notice: 'Applicant has been unlocked.'
  end

  # Sends email to applicant containg authentication token
  def email
    @applicant = Applicant.find(params[:id])
    @applicant.update_general_information_email!(current_user)
    redirect_to @applicant, notice: 'Applicant has been notified by email to update application information.'
  end

  def annual_email
    @applicant = Applicant.find(params[:id])
    @applicant.send_annual_reminder!(current_user, Date.today.year, "Please Update Your Annual Information for #{Date.today.year}", "Update your information here:")
    redirect_to @applicant, notice: 'Applicant has been notified by email to update application annual information.'
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
    # params[:applicant][:desired_start_date] = Date.strptime(params[:applicant][:desired_start_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:desired_start_date].blank?
    # params[:applicant][:review_date] = Date.strptime(params[:applicant][:review_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:review_date].blank?
    # params[:applicant][:training_period_start_date] = Date.strptime(params[:applicant][:training_period_start_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:training_period_start_date].blank?
    # params[:applicant][:training_period_end_date] = Date.strptime(params[:applicant][:training_period_end_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:training_period_end_date].blank?

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
    # params[:applicant][:desired_start_date] = Date.strptime(params[:applicant][:desired_start_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:desired_start_date].blank?
    # params[:applicant][:review_date] = Date.strptime(params[:applicant][:review_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:review_date].blank?
    # params[:applicant][:training_period_start_date] = Date.strptime(params[:applicant][:training_period_start_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:training_period_start_date].blank?
    # params[:applicant][:training_period_end_date] = Date.strptime(params[:applicant][:training_period_end_date], "%m/%d/%Y") if params[:applicant] and not params[:applicant][:training_period_end_date].blank?

    @applicant = Applicant.find(params[:id])

    @applicant.skip_reconfirmation!

    respond_to do |format|
      if @applicant.update_attributes(post_params)
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
    params[:applicant] ||= {}
    [:desired_start_date, :review_date, :training_period_start_date, :training_period_end_date].each do |date|
      params[:applicant][date] = parse_date(params[:applicant][date])
    end

    params[:applicant][:degree_types] ||= []
    params[:applicant][:urm_types] ||= []

    if current_user and current_user.administrator?
      params[:applicant]
    else
      params[:applicant].slice(
        # Applicant Information
        :email, :first_name, :last_name, :middle_initial, :applicant_type, :tge, :desired_start_date, :personal_statement, :alien_registration_number, :citizenship_status,
        # Education
        :advisor, :concentration_major, :current_institution, :cv, :degree_sought, :department_program, :expected_year,
        :preferred_preceptor_id, :preferred_preceptor_two_id, :preferred_preceptor_three_id, :thesis, :degrees_earned, :current_title,
        :previous_nsra_support, :degree_types,
        # Demographic Information
        :gender, :disabled, :disabled_description, :disadvantaged, :urm, :urm_types, :marital_status,
        # Contact Information
        :phone, :address1, :address2, :city, :state, :country, :zip_code,
        # Postdoc Only
        :residency,
        # Trainee Only
        :research_project_title,
        # Applicant Assurance
        :assurance, :publish, :letters_from_a, :letters_from_b, :letters_from_c,
        # Uploaded Curriculum Vitae
        :curriculum_vitae, :curriculum_vitae_uploaded_at, :curriculum_vitae_cache
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
        'Advisor', 'Concentration/Major', 'Current Institution', 'CV', 'Degree Sought', 'Department/Program', 'Expected Year',
        'Preferred Preceptor ID', 'Preferred Preceptor Two ID', 'Preferred Preceptor Three ID', 'Thesis', 'Degrees Earned', 'Current Title',
        'Previous NSRA Support', 'Degree Types',
        # Demographic Information
        'Gender', 'Disabled', 'Disabled Description', 'Disadvantaged', 'URM', 'URM Types', 'Marital Status',
        # Contact Information
        'Phone', 'Address1', 'Address2', 'City', 'State', 'Country', 'Zip Code',
        # Postdoc Only
        'Residency',
        # Trainee Only
        'Research Project Title',
        # Applicant Assurance
        'Assurance', 'Letters From A', 'Letters From B', 'Letters From C',
        # Administrator Only
        'Reviewed', 'Review Date', 'Offered', 'Accepted', 'Enrolled', 'CV Number', 'Degree Type', 'Trainee Code', 'Year Department Program',
        'Status', 'Training Grant Years', 'Supported by Training Grant', 'Training Period Start Date', 'Training Period End Date', 'Notes'
      ]

      applicant_scope.each do |a|
        row = [
          a.id,
          # Applicant Information
          a.email, a.last_name, a.first_name, a.middle_initial, a.applicant_type, a.tge, a.desired_start_date, a.personal_statement, a.alien_registration_number, a.citizenship_status,
          # Education
          a.advisor, a.concentration_major, a.current_institution, a.cv, a.degree_sought, a.department_program, a.expected_year,
          a.preferred_preceptor_id, a.preferred_preceptor_two_id, a.preferred_preceptor_three_id, a.thesis, a.degrees_earned, a.current_title,
          a.previous_nsra_support, a.degree_types,
          # Demographic Information
          a.gender, a.disabled, a.disabled_description, a.disadvantaged, a.urm, a.urm_types, a.marital_status,
          # Contact Information
          a.phone, a.address1, a.address2, a.city, a.state, a.country, a.zip_code,
          # Postdoc Only
          a.residency,
          # Trainee Only
          a.research_project_title,
          # Applicant Assurance
          a.assurance, a.letters_from_a, a.letters_from_b, a.letters_from_c,
          # Administrator Only
          a.reviewed, a.review_date, a.offered, a.accepted, a.enrolled, a.cv_number, a.degree_type, a.trainee_code, a.year_department_program,
          a.status, a.training_grant_years, a.supported_by_tg, a.training_period_start_date, a.training_period_end_date, a.notes
        ]
        csv << row
      end
    end

    send_data @csv_string, type: 'text/csv; charset=iso-8859-1; header=present',
                           disposition: "attachment; filename=\"Training Grant Applicants and Trainees #{Time.now.strftime("%Y.%m.%d %Ih%M %p")}.csv\""
  end

end
