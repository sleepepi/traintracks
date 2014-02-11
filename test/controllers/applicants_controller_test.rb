require 'test_helper'

class ApplicantsControllerTest < ActionController::TestCase
  setup do
    login(users(:administrator))
    @applicant = applicants(:one)
  end

  test "should get csv" do
    get :index, format: 'csv'
    assert_not_nil assigns(:csv_string)
    assert_response :success
  end

  # Currently no fixtures have enrolled trainees
  test "should not get csv if no applicants are selected" do
    get :index, format: 'csv', enrolled: 'except'
    assert_nil assigns(:csv_string)
    assert_equal flash[:alert], 'No data was exported since no applicants matched the specified filters.'
    assert_redirected_to applicants_path
  end

  test "should send annual reminder email" do
    post :send_annual_reminder_email, year: '2001', subject: 'Subject', body: 'Body'
    assert_equal "Annual Reminder email successfully sent to #{Applicant.supported_by_tg_in_last_ten_years.count} applicants.", flash[:notice]
    assert_redirected_to applicants_path
  end

  test "should send annual reminder email to individual applicant" do
    post :send_annual_reminder_email, year: '2001', subject: 'Subject', body: 'Body', applicant_id: applicants(:one).id
    assert_equal "Annual Reminder email successfully sent to #{applicants(:one).name}.", flash[:notice]
    assert_redirected_to applicants(:one)
  end

  test "should not send annual reminder email with year less than 2001" do
    post :send_annual_reminder_email, year: '2000', subject: 'Subject', body: 'Body'
    assert_equal "'2000' is not a valid year.", flash[:alert]
    assert_redirected_to applicants_path
  end

  test "should get program requirements" do
    get :program_requirements
    assert_response :success
    assert_not_nil assigns(:applicants)
  end

  test "should get csv of program requirements" do
    get :program_requirements, format: 'csv'
    assert_not_nil assigns(:csv_string)
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:applicants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create applicant" do
    assert_difference('Applicant.count') do
      post :create, applicant: { accepted: @applicant.accepted, address1: @applicant.address1, address2: @applicant.address2, cv_number: @applicant.cv_number, applicant_type: @applicant.applicant_type, city: @applicant.city, country: @applicant.country, current_institution: @applicant.current_institution, current_position: @applicant.current_position, degree_sought: @applicant.degree_sought, degree_type: @applicant.degree_type, degrees_earned: @applicant.degrees_earned, department_program: @applicant.department_program, disabled: @applicant.disabled, disadvantaged: @applicant.disadvantaged, enrolled: @applicant.enrolled, expected_year: @applicant.expected_year, first_name: @applicant.first_name, last_name: @applicant.last_name, middle_initial: @applicant.middle_initial, notes: @applicant.notes, offered: @applicant.offered, phone: @applicant.phone, preferred_preceptor_id: @applicant.preferred_preceptor_id, primary_preceptor_id: @applicant.primary_preceptor_id, research_project_title: @applicant.research_project_title, residency: @applicant.residency, review_date: "1/30/2012", reviewed: @applicant.reviewed, secondary_preceptor_id: @applicant.secondary_preceptor_id, state: @applicant.state, status: @applicant.status, supported_by_tg: @applicant.supported_by_tg, training_grant_years: @applicant.training_grant_years, tge: @applicant.tge, trainee_code: @applicant.trainee_code, training_period_end_date: "2/10/2013", training_period_start_date: "2/10/2012", urm: @applicant.urm, zip_code: @applicant.zip_code, desired_start_date: "4/16/2012", marital_status: @applicant.marital_status, assurance: @applicant.assurance, email: 'three@example.com', password: 'password', personal_statement: @applicant.personal_statement, alien_registration_number: @applicant.alien_registration_number, citizenship_status: @applicant.citizenship_status, letters_from_a: @applicant.letters_from_a, letters_from_b: @applicant.letters_from_b, letters_from_c: @applicant.letters_from_c, gender: @applicant.gender, urm_types: @applicant.urm_types }
    end

    assert_redirected_to applicant_path(assigns(:applicant))
  end

  test "should show applicant" do
    get :show, id: @applicant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @applicant
    assert_response :success
  end

  test "should update applicant" do
    put :update, id: @applicant, applicant: { accepted: @applicant.accepted, address1: @applicant.address1, address2: @applicant.address2, cv_number: @applicant.cv_number, applicant_type: @applicant.applicant_type, city: @applicant.city, country: @applicant.country, current_institution: @applicant.current_institution, current_position: @applicant.current_position, degree_sought: @applicant.degree_sought, degree_type: @applicant.degree_type, degrees_earned: @applicant.degrees_earned, department_program: @applicant.department_program, disabled: @applicant.disabled, disadvantaged: @applicant.disadvantaged, email: @applicant.email, enrolled: @applicant.enrolled, expected_year: @applicant.expected_year, first_name: @applicant.first_name, last_name: @applicant.last_name, middle_initial: @applicant.middle_initial, notes: @applicant.notes, offered: @applicant.offered, phone: @applicant.phone, preferred_preceptor_id: @applicant.preferred_preceptor_id, primary_preceptor_id: @applicant.primary_preceptor_id, research_project_title: @applicant.research_project_title, residency: @applicant.residency, review_date: "1/30/2012", reviewed: @applicant.reviewed, secondary_preceptor_id: @applicant.secondary_preceptor_id, state: @applicant.state, status: @applicant.status, supported_by_tg: @applicant.supported_by_tg, training_grant_years: @applicant.training_grant_years, tge: @applicant.tge, trainee_code: @applicant.trainee_code, training_period_end_date: "2/10/2013", training_period_start_date: "2/10/2012", urm: @applicant.urm, zip_code: @applicant.zip_code, desired_start_date: "4/16/2012", marital_status: @applicant.marital_status, assurance: @applicant.assurance, personal_statement: @applicant.personal_statement, alien_registration_number: @applicant.alien_registration_number, citizenship_status: @applicant.citizenship_status, letters_from_a: @applicant.letters_from_a, letters_from_b: @applicant.letters_from_b, letters_from_c: @applicant.letters_from_c, gender: @applicant.gender, urm_types: @applicant.urm_types }
    assert_redirected_to applicant_path(assigns(:applicant))
  end

  test "should update applicant with blank email" do
    put :update, id: @applicant, applicant: { accepted: @applicant.accepted, address1: @applicant.address1, address2: @applicant.address2, cv_number: @applicant.cv_number, applicant_type: @applicant.applicant_type, city: @applicant.city, country: @applicant.country, current_institution: @applicant.current_institution, current_position: @applicant.current_position, degree_sought: @applicant.degree_sought, degree_type: @applicant.degree_type, degrees_earned: @applicant.degrees_earned, department_program: @applicant.department_program, disabled: @applicant.disabled, disadvantaged: @applicant.disadvantaged, email: "", enrolled: @applicant.enrolled, expected_year: @applicant.expected_year, first_name: @applicant.first_name, last_name: @applicant.last_name, middle_initial: @applicant.middle_initial, notes: @applicant.notes, offered: @applicant.offered, phone: @applicant.phone, preferred_preceptor_id: @applicant.preferred_preceptor_id, primary_preceptor_id: @applicant.primary_preceptor_id, research_project_title: @applicant.research_project_title, residency: @applicant.residency, review_date: "1/30/2012", reviewed: @applicant.reviewed, secondary_preceptor_id: @applicant.secondary_preceptor_id, state: @applicant.state, status: @applicant.status, supported_by_tg: @applicant.supported_by_tg, training_grant_years: @applicant.training_grant_years, tge: @applicant.tge, trainee_code: @applicant.trainee_code, training_period_end_date: "2/10/2013", training_period_start_date: "2/10/2012", urm: @applicant.urm, zip_code: @applicant.zip_code, desired_start_date: "4/16/2012", marital_status: @applicant.marital_status, assurance: @applicant.assurance, personal_statement: @applicant.personal_statement, alien_registration_number: @applicant.alien_registration_number, citizenship_status: @applicant.citizenship_status, letters_from_a: @applicant.letters_from_a, letters_from_b: @applicant.letters_from_b, letters_from_c: @applicant.letters_from_c, gender: @applicant.gender, urm_types: @applicant.urm_types }
    assert_redirected_to applicant_path(assigns(:applicant))
  end

  test "should destroy applicant" do
    assert_difference('Applicant.current.count', -1) do
      delete :destroy, id: @applicant
    end

    assert_redirected_to applicants_path
  end

  test "should get dashboard" do
    login(applicants(:one))
    get :dashboard
    assert_response :success
  end

  test "should edit me" do
    login(applicants(:one))
    get :edit_me
    assert_response :success
  end

  test "should update me and save draft" do
    login(applicants(:one))
    put :update_me, applicant: {
        publish: '0',
        # Basic Information
        email: @applicant.email, first_name: @applicant.first_name, last_name: @applicant.last_name, middle_initial: @applicant.middle_initial, applicant_type: @applicant.applicant_type,
        desired_start_date: "8/28/2012", personal_statement: @applicant.personal_statement, alien_registration_number: @applicant.alien_registration_number, citizenship_status: @applicant.citizenship_status,
        # Contact Information
        phone: @applicant.phone, address1: @applicant.address1, address2: @applicant.address2, city: @applicant.city, state: @applicant.state, country: @applicant.country, zip_code: @applicant.zip_code,
        # Education
        curriculum_vitae: fixture_file_upload('../../test/support/applicants/curriculum_vitae/test_01.doc'),
        current_institution: @applicant.current_institution, department_program: @applicant.department_program, current_position: @applicant.current_position,
        degrees_earned: @applicant.degrees_earned,
        degree_sought: @applicant.degree_sought, expected_year: @applicant.expected_year,
        residency: @applicant.residency, research_interests: @applicant.research_interests,
        preferred_preceptor_id: @applicant.preferred_preceptor_id, preferred_preceptor_two_id: @applicant.preferred_preceptor_two_id, preferred_preceptor_three_id: @applicant.preferred_preceptor_three_id,
        previous_nrsa_support: @applicant.previous_nrsa_support,
        # Demographic Information
        gender: @applicant.gender, disabled: @applicant.disabled, disadvantaged: @applicant.disadvantaged, urm: @applicant.urm, urm_types: @applicant.urm_types, marital_status: @applicant.marital_status,
        # Applicant Assurance
        letters_from_a: @applicant.letters_from_a, letters_from_b: @applicant.letters_from_b, letters_from_c: @applicant.letters_from_c, assurance: @applicant.assurance
    }

    assert_equal [], @controller.current_applicant.errors.full_messages
    assert_equal 'Application successfully updated.', flash[:notice]
    assert_redirected_to dashboard_applicants_path
  end

  test "should not update me with blank degrees_earned" do
    login(applicants(:one))
    put :update_me, applicant: {
        publish: '1',
        # Basic Information
        email: @applicant.email, first_name: @applicant.first_name, last_name: @applicant.last_name, middle_initial: @applicant.middle_initial, applicant_type: @applicant.applicant_type,
        desired_start_date: "8/28/2012", personal_statement: @applicant.personal_statement, alien_registration_number: @applicant.alien_registration_number, citizenship_status: @applicant.citizenship_status,
        # Contact Information
        phone: @applicant.phone, address1: @applicant.address1, address2: @applicant.address2, city: @applicant.city, state: @applicant.state, country: @applicant.country, zip_code: @applicant.zip_code,
        # Education
        curriculum_vitae: fixture_file_upload('../../test/support/applicants/curriculum_vitae/test_01.docx'),
        current_institution: @applicant.current_institution, department_program: @applicant.department_program, current_position: @applicant.current_position,
        degrees_earned: [{ degree_type: '', institution: '', year: '' }], # Blank Degrees
        degree_sought: @applicant.degree_sought, expected_year: @applicant.expected_year,
        residency: @applicant.residency, research_interests: @applicant.research_interests,
        preferred_preceptor_id: @applicant.preferred_preceptor_id, preferred_preceptor_two_id: @applicant.preferred_preceptor_two_id, preferred_preceptor_three_id: @applicant.preferred_preceptor_three_id,
        previous_nrsa_support: @applicant.previous_nrsa_support,
        # Demographic Information
        gender: @applicant.gender, disabled: @applicant.disabled, disadvantaged: @applicant.disadvantaged, urm: @applicant.urm, urm_types: @applicant.urm_types, marital_status: @applicant.marital_status,
        # Applicant Assurance
        letters_from_a: @applicant.letters_from_a, letters_from_b: @applicant.letters_from_b, letters_from_c: @applicant.letters_from_c, assurance: @applicant.assurance
    }

    assert_equal ["degree type can't be blank", "institution can't be blank", "year can't be blank"], @controller.current_applicant.errors[:degrees_earned]
    assert_template 'edit_me'
    assert_response :success
  end

  test "should update me and publish" do
    login(applicants(:one))
    put :update_me, applicant: {
        publish: '1',
        # Basic Information
        email: @applicant.email, first_name: @applicant.first_name, last_name: @applicant.last_name, middle_initial: @applicant.middle_initial, applicant_type: @applicant.applicant_type,
        desired_start_date: "8/28/2012", personal_statement: @applicant.personal_statement, alien_registration_number: @applicant.alien_registration_number, citizenship_status: @applicant.citizenship_status,
        # Contact Information
        phone: @applicant.phone, address1: @applicant.address1, address2: @applicant.address2, city: @applicant.city, state: @applicant.state, country: @applicant.country, zip_code: @applicant.zip_code,
        # Education
        curriculum_vitae: fixture_file_upload('../../test/support/applicants/curriculum_vitae/test_01.pdf'),
        current_institution: @applicant.current_institution, department_program: @applicant.department_program, current_position: @applicant.current_position,
        degrees_earned: @applicant.degrees_earned,
        degree_sought: @applicant.degree_sought, expected_year: @applicant.expected_year,
        residency: @applicant.residency, research_interests: @applicant.research_interests,
        preferred_preceptor_id: @applicant.preferred_preceptor_id, preferred_preceptor_two_id: @applicant.preferred_preceptor_two_id, preferred_preceptor_three_id: @applicant.preferred_preceptor_three_id,
        previous_nrsa_support: @applicant.previous_nrsa_support,
        # Demographic Information
        gender: @applicant.gender, disabled: @applicant.disabled, disadvantaged: @applicant.disadvantaged, urm: @applicant.urm, urm_types: @applicant.urm_types, marital_status: @applicant.marital_status,
        # Applicant Assurance
        letters_from_a: @applicant.letters_from_a, letters_from_b: @applicant.letters_from_b, letters_from_c: @applicant.letters_from_c, assurance: @applicant.assurance
    }

    assert_equal [], @controller.current_applicant.errors.full_messages
    assert_equal 'Application successfully updated.', flash[:notice]
    assert_redirected_to dashboard_applicants_path
  end
end
