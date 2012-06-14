require 'test_helper'

class ApplicantsControllerTest < ActionController::TestCase
  setup do
    login(users(:administrator))
    @applicant = applicants(:one)
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

  # Temporarily disabled to figure out why actionmailer is called when applicant is created
  # even though applicant.skip_confirmation! is being called.
  # test "should create applicant" do
  #   assert_difference('Applicant.count') do
  #     post :create, applicant: { accepted: @applicant.accepted, address1: @applicant.address1, address2: @applicant.address2, advisor: @applicant.advisor, cv_number: @applicant.cv_number, applicant_type: @applicant.applicant_type, city: @applicant.city, concentration_major: @applicant.concentration_major, country: @applicant.country, coursework_completed: @applicant.coursework_completed, current_institution: @applicant.current_institution, current_title: @applicant.current_title, cv: @applicant.cv, degree_sought: @applicant.degree_sought, degree_type: @applicant.degree_type, degrees_earned: @applicant.degrees_earned, department_program: @applicant.department_program, disabled: @applicant.disabled, disadvantaged: @applicant.disadvantaged, enrolled: @applicant.enrolled, expected_year: @applicant.expected_year, first_name: @applicant.first_name, last_name: @applicant.last_name, middle_initial: @applicant.middle_initial, notes: @applicant.notes, offered: @applicant.offered, phone: @applicant.phone, preferred_preceptor_id: @applicant.preferred_preceptor_id, presentations: @applicant.presentations, previous_institutions: @applicant.previous_institutions, primary_preceptor_id: @applicant.primary_preceptor_id, pubs_not_prev_rep: @applicant.pubs_not_prev_rep, research_description: @applicant.research_description, research_project_title: @applicant.research_project_title, residency: @applicant.residency, review_date: "1/30/2012", reviewed: @applicant.reviewed, secondary_preceptor_id: @applicant.secondary_preceptor_id, source_of_support: @applicant.source_of_support, state: @applicant.state, status: @applicant.status, supported_by_tg: @applicant.supported_by_tg, training_grant_years: @applicant.training_grant_years, tge: @applicant.tge, thesis: @applicant.thesis, trainee_code: @applicant.trainee_code, training_period_end_date: "2/10/2013", training_period_start_date: "2/10/2012", urm: @applicant.urm, year: @applicant.year, year_department_program: @applicant.year_department_program, zip_code: @applicant.zip_code, desired_start_date: "4/16/2012", marital_status: @applicant.marital_status, assurance: @applicant.assurance, email: 'three@example.com', password: 'password', personal_statement: @applicant.personal_statement, alien_registration_number: @applicant.alien_registration_number, citizenship_status: @applicant.citizenship_status, degree_types: @applicant.degree_types, letters_from_a: @applicant.letters_from_a, letters_from_b: @applicant.letters_from_b, letters_from_c: @applicant.letters_from_c, gender: @applicant.gender, urm_types: @applicant.urm_types }
  #   end

  #   assert_redirected_to applicant_path(assigns(:applicant))
  # end

  test "should show applicant" do
    get :show, id: @applicant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @applicant
    assert_response :success
  end

  test "should update applicant" do
    put :update, id: @applicant, applicant: { accepted: @applicant.accepted, address1: @applicant.address1, address2: @applicant.address2, advisor: @applicant.advisor, cv_number: @applicant.cv_number, applicant_type: @applicant.applicant_type, city: @applicant.city, concentration_major: @applicant.concentration_major, country: @applicant.country, coursework_completed: @applicant.coursework_completed, current_institution: @applicant.current_institution, current_title: @applicant.current_title, cv: @applicant.cv, degree_sought: @applicant.degree_sought, degree_type: @applicant.degree_type, degrees_earned: @applicant.degrees_earned, department_program: @applicant.department_program, disabled: @applicant.disabled, disadvantaged: @applicant.disadvantaged, email: @applicant.email, enrolled: @applicant.enrolled, expected_year: @applicant.expected_year, first_name: @applicant.first_name, last_name: @applicant.last_name, middle_initial: @applicant.middle_initial, notes: @applicant.notes, offered: @applicant.offered, phone: @applicant.phone, preferred_preceptor_id: @applicant.preferred_preceptor_id, presentations: @applicant.presentations, previous_institutions: @applicant.previous_institutions, primary_preceptor_id: @applicant.primary_preceptor_id, pubs_not_prev_rep: @applicant.pubs_not_prev_rep, research_description: @applicant.research_description, research_project_title: @applicant.research_project_title, residency: @applicant.residency, review_date: "1/30/2012", reviewed: @applicant.reviewed, secondary_preceptor_id: @applicant.secondary_preceptor_id, source_of_support: @applicant.source_of_support, state: @applicant.state, status: @applicant.status, supported_by_tg: @applicant.supported_by_tg, training_grant_years: @applicant.training_grant_years, tge: @applicant.tge, thesis: @applicant.thesis, trainee_code: @applicant.trainee_code, training_period_end_date: "2/10/2013", training_period_start_date: "2/10/2012", urm: @applicant.urm, year: @applicant.year, year_department_program: @applicant.year_department_program, zip_code: @applicant.zip_code, desired_start_date: "4/16/2012", marital_status: @applicant.marital_status, assurance: @applicant.assurance, personal_statement: @applicant.personal_statement, alien_registration_number: @applicant.alien_registration_number, citizenship_status: @applicant.citizenship_status, degree_types: @applicant.degree_types, letters_from_a: @applicant.letters_from_a, letters_from_b: @applicant.letters_from_b, letters_from_c: @applicant.letters_from_c, gender: @applicant.gender, urm_types: @applicant.urm_types }
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

  test "should update me" do
    login(applicants(:one))
    put :update_me, applicant: { publish: '0', address1: @applicant.address1, address2: @applicant.address2, advisor: @applicant.advisor, cv_number: @applicant.cv_number, applicant_type: @applicant.applicant_type, city: @applicant.city, concentration_major: @applicant.concentration_major, country: @applicant.country, coursework_completed: @applicant.coursework_completed, current_institution: @applicant.current_institution, current_title: @applicant.current_title, cv: @applicant.cv, degree_sought: @applicant.degree_sought, degree_type: @applicant.degree_type, degrees_earned: @applicant.degrees_earned, department_program: @applicant.department_program, disabled: @applicant.disabled, disadvantaged: @applicant.disadvantaged, expected_year: @applicant.expected_year, first_name: @applicant.first_name, last_name: @applicant.last_name, middle_initial: @applicant.middle_initial, phone: @applicant.phone, preferred_preceptor_id: @applicant.preferred_preceptor_id, presentations: @applicant.presentations, previous_institutions: @applicant.previous_institutions, primary_preceptor_id: @applicant.primary_preceptor_id, pubs_not_prev_rep: @applicant.pubs_not_prev_rep, research_description: @applicant.research_description, research_project_title: @applicant.research_project_title, residency: @applicant.residency, secondary_preceptor_id: @applicant.secondary_preceptor_id, source_of_support: @applicant.source_of_support, state: @applicant.state, status: @applicant.status, supported_by_tg: @applicant.supported_by_tg, training_grant_years: @applicant.training_grant_years, tge: @applicant.tge, thesis: @applicant.thesis, trainee_code: @applicant.trainee_code, training_period_end_date: "2/10/2013", training_period_start_date: "2/10/2012", urm: @applicant.urm, year: @applicant.year, year_department_program: @applicant.year_department_program, zip_code: @applicant.zip_code, desired_start_date: "4/16/2012", marital_status: @applicant.marital_status, assurance: @applicant.assurance, personal_statement: @applicant.personal_statement, alien_registration_number: @applicant.alien_registration_number, citizenship_status: @applicant.citizenship_status, degree_types: @applicant.degree_types, letters_from_a: @applicant.letters_from_a, letters_from_b: @applicant.letters_from_b, letters_from_c: @applicant.letters_from_c, gender: @applicant.gender, urm_types: @applicant.urm_types }

    assert_equal 'Application successfully updated.', flash[:notice]
    assert_redirected_to dashboard_applicants_path
  end
end
