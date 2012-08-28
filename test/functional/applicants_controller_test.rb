require 'test_helper'

class ApplicantsControllerTest < ActionController::TestCase
  setup do
    login(users(:administrator))
    @applicant = applicants(:one)
  end

  test "should get csv" do
    get :index, format: 'csv'
    assert_not_nil assigns(:csv_string)
    assert_not_nil assigns(:applicant_count)
    assert_response :success
  end

  # Currently no fixtures have enrolled trainees
  test "should not get csv if no applicants are selected" do
    get :index, format: 'csv', enrolled: 'only'
    assert_equal 0, assigns(:applicant_count)
    assert_nil assigns(:csv_string)
    assert_equal flash[:alert], 'No data was exported since no applicants matched the specified filters.'
    assert_redirected_to applicants_path
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
      post :create, applicant: { accepted: @applicant.accepted, address1: @applicant.address1, address2: @applicant.address2, advisor: @applicant.advisor, cv_number: @applicant.cv_number, applicant_type: @applicant.applicant_type, city: @applicant.city, concentration_major: @applicant.concentration_major, country: @applicant.country, current_institution: @applicant.current_institution, current_position: @applicant.current_position, cv: @applicant.cv, degree_sought: @applicant.degree_sought, degree_type: @applicant.degree_type, degrees_earned: @applicant.degrees_earned, department_program: @applicant.department_program, disabled: @applicant.disabled, disadvantaged: @applicant.disadvantaged, enrolled: @applicant.enrolled, expected_year: @applicant.expected_year, first_name: @applicant.first_name, last_name: @applicant.last_name, middle_initial: @applicant.middle_initial, notes: @applicant.notes, offered: @applicant.offered, phone: @applicant.phone, preferred_preceptor_id: @applicant.preferred_preceptor_id, primary_preceptor_id: @applicant.primary_preceptor_id, research_project_title: @applicant.research_project_title, residency: @applicant.residency, review_date: "1/30/2012", reviewed: @applicant.reviewed, secondary_preceptor_id: @applicant.secondary_preceptor_id, state: @applicant.state, status: @applicant.status, supported_by_tg: @applicant.supported_by_tg, training_grant_years: @applicant.training_grant_years, tge: @applicant.tge, thesis: @applicant.thesis, trainee_code: @applicant.trainee_code, training_period_end_date: "2/10/2013", training_period_start_date: "2/10/2012", urm: @applicant.urm, zip_code: @applicant.zip_code, desired_start_date: "4/16/2012", marital_status: @applicant.marital_status, assurance: @applicant.assurance, email: 'three@example.com', password: 'password', personal_statement: @applicant.personal_statement, alien_registration_number: @applicant.alien_registration_number, citizenship_status: @applicant.citizenship_status, degree_types: @applicant.degree_types, letters_from_a: @applicant.letters_from_a, letters_from_b: @applicant.letters_from_b, letters_from_c: @applicant.letters_from_c, gender: @applicant.gender, urm_types: @applicant.urm_types }
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
    put :update, id: @applicant, applicant: { accepted: @applicant.accepted, address1: @applicant.address1, address2: @applicant.address2, advisor: @applicant.advisor, cv_number: @applicant.cv_number, applicant_type: @applicant.applicant_type, city: @applicant.city, concentration_major: @applicant.concentration_major, country: @applicant.country, current_institution: @applicant.current_institution, current_position: @applicant.current_position, cv: @applicant.cv, degree_sought: @applicant.degree_sought, degree_type: @applicant.degree_type, degrees_earned: @applicant.degrees_earned, department_program: @applicant.department_program, disabled: @applicant.disabled, disadvantaged: @applicant.disadvantaged, email: @applicant.email, enrolled: @applicant.enrolled, expected_year: @applicant.expected_year, first_name: @applicant.first_name, last_name: @applicant.last_name, middle_initial: @applicant.middle_initial, notes: @applicant.notes, offered: @applicant.offered, phone: @applicant.phone, preferred_preceptor_id: @applicant.preferred_preceptor_id, primary_preceptor_id: @applicant.primary_preceptor_id, research_project_title: @applicant.research_project_title, residency: @applicant.residency, review_date: "1/30/2012", reviewed: @applicant.reviewed, secondary_preceptor_id: @applicant.secondary_preceptor_id, state: @applicant.state, status: @applicant.status, supported_by_tg: @applicant.supported_by_tg, training_grant_years: @applicant.training_grant_years, tge: @applicant.tge, thesis: @applicant.thesis, trainee_code: @applicant.trainee_code, training_period_end_date: "2/10/2013", training_period_start_date: "2/10/2012", urm: @applicant.urm, zip_code: @applicant.zip_code, desired_start_date: "4/16/2012", marital_status: @applicant.marital_status, assurance: @applicant.assurance, personal_statement: @applicant.personal_statement, alien_registration_number: @applicant.alien_registration_number, citizenship_status: @applicant.citizenship_status, degree_types: @applicant.degree_types, letters_from_a: @applicant.letters_from_a, letters_from_b: @applicant.letters_from_b, letters_from_c: @applicant.letters_from_c, gender: @applicant.gender, urm_types: @applicant.urm_types }
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
        current_institution: @applicant.current_institution, department_program: @applicant.department_program, current_position: @applicant.current_position,
        degrees_earned: @applicant.degrees_earned,
        degree_types: @applicant.degree_types, degree_sought: @applicant.degree_sought, expected_year: @applicant.expected_year, concentration_major: @applicant.concentration_major,
        advisor: @applicant.advisor, thesis: @applicant.thesis, residency: @applicant.residency, research_interests: @applicant.research_interests,
        preferred_preceptor_id: @applicant.preferred_preceptor_id, preferred_preceptor_two_id: @applicant.preferred_preceptor_two_id, preferred_preceptor_three_id: @applicant.preferred_preceptor_three_id,
        previous_nrsa_support: @applicant.previous_nrsa_support,
        # Demographic Information
        gender: @applicant.gender, disabled: @applicant.disabled, disadvantaged: @applicant.disadvantaged, urm: @applicant.urm, urm_types: @applicant.urm_types, marital_status: @applicant.marital_status,
        # Applicant Assurance
        letters_from_a: @applicant.letters_from_a, letters_from_b: @applicant.letters_from_b, letters_from_c: @applicant.letters_from_c, assurance: @applicant.assurance
    }

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
        current_institution: @applicant.current_institution, department_program: @applicant.department_program, current_position: @applicant.current_position,
        degrees_earned: [{ degree_type: '', institution: '', year: '' }], # Blank Degrees
        degree_types: @applicant.degree_types, degree_sought: @applicant.degree_sought, expected_year: @applicant.expected_year, concentration_major: @applicant.concentration_major,
        advisor: @applicant.advisor, thesis: @applicant.thesis, residency: @applicant.residency, research_interests: @applicant.research_interests,
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
end
