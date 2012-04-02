require 'test_helper'

class ApplicantsControllerTest < ActionController::TestCase
  setup do
    login(users(:valid))
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

  test "should create applicant" do
    assert_difference('Applicant.count') do
      post :create, applicant: { accepted: @applicant.accepted, address1: @applicant.address1, address2: @applicant.address2, advisor: @applicant.advisor, applicant_number: @applicant.applicant_number, applicant_type: @applicant.applicant_type, appointment_type: @applicant.appointment_type, city: @applicant.city, concentration_major: @applicant.concentration_major, country: @applicant.country, coursework_comp: @applicant.coursework_comp, current_institution: @applicant.current_institution, current_position_or_source_of_support: @applicant.current_position_or_source_of_support, cv: @applicant.cv, degree_sought: @applicant.degree_sought, degree_type: @applicant.degree_type, degrees: @applicant.degrees, department_program: @applicant.department_program, disabled: @applicant.disabled, disadvantaged: @applicant.disadvantaged, email: @applicant.email, enrolled: @applicant.enrolled, expected_year: @applicant.expected_year, fax: @applicant.fax, first_name: @applicant.first_name, grant_years: @applicant.grant_years, last_name: @applicant.last_name, middle_initial: @applicant.middle_initial, notes: @applicant.notes, offered: @applicant.offered, phone: @applicant.phone, preferred_preceptor_id: @applicant.preferred_preceptor_id, presentations: @applicant.presentations, previous_institutions: @applicant.previous_institutions, primary_preceptor_id: @applicant.primary_preceptor_id, pubs_not_prev_rep: @applicant.pubs_not_prev_rep, research_description: @applicant.research_description, research_project_title: @applicant.research_project_title, residency: @applicant.residency, review_date: @applicant.review_date, reviewed: @applicant.reviewed, secondary_preceptor_id: @applicant.secondary_preceptor_id, source_of_support: @applicant.source_of_support, state: @applicant.state, status: @applicant.status, summer: @applicant.summer, supported_by_tg: @applicant.supported_by_tg, tg_years: @applicant.tg_years, tge: @applicant.tge, thesis: @applicant.thesis, trainee_code: @applicant.trainee_code, training_period_end_date: @applicant.training_period_end_date, training_period_start_date: @applicant.training_period_start_date, urm: @applicant.urm, year: @applicant.year, year_department_program: @applicant.year_department_program, zip_code: @applicant.zip_code }
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
    put :update, id: @applicant, applicant: { accepted: @applicant.accepted, address1: @applicant.address1, address2: @applicant.address2, advisor: @applicant.advisor, applicant_number: @applicant.applicant_number, applicant_type: @applicant.applicant_type, appointment_type: @applicant.appointment_type, city: @applicant.city, concentration_major: @applicant.concentration_major, country: @applicant.country, coursework_comp: @applicant.coursework_comp, current_institution: @applicant.current_institution, current_position_or_source_of_support: @applicant.current_position_or_source_of_support, cv: @applicant.cv, degree_sought: @applicant.degree_sought, degree_type: @applicant.degree_type, degrees: @applicant.degrees, department_program: @applicant.department_program, disabled: @applicant.disabled, disadvantaged: @applicant.disadvantaged, email: @applicant.email, enrolled: @applicant.enrolled, expected_year: @applicant.expected_year, fax: @applicant.fax, first_name: @applicant.first_name, grant_years: @applicant.grant_years, last_name: @applicant.last_name, middle_initial: @applicant.middle_initial, notes: @applicant.notes, offered: @applicant.offered, phone: @applicant.phone, preferred_preceptor_id: @applicant.preferred_preceptor_id, presentations: @applicant.presentations, previous_institutions: @applicant.previous_institutions, primary_preceptor_id: @applicant.primary_preceptor_id, pubs_not_prev_rep: @applicant.pubs_not_prev_rep, research_description: @applicant.research_description, research_project_title: @applicant.research_project_title, residency: @applicant.residency, review_date: @applicant.review_date, reviewed: @applicant.reviewed, secondary_preceptor_id: @applicant.secondary_preceptor_id, source_of_support: @applicant.source_of_support, state: @applicant.state, status: @applicant.status, summer: @applicant.summer, supported_by_tg: @applicant.supported_by_tg, tg_years: @applicant.tg_years, tge: @applicant.tge, thesis: @applicant.thesis, trainee_code: @applicant.trainee_code, training_period_end_date: @applicant.training_period_end_date, training_period_start_date: @applicant.training_period_start_date, urm: @applicant.urm, year: @applicant.year, year_department_program: @applicant.year_department_program, zip_code: @applicant.zip_code }
    assert_redirected_to applicant_path(assigns(:applicant))
  end

  test "should destroy applicant" do
    assert_difference('Applicant.current.count', -1) do
      delete :destroy, id: @applicant
    end

    assert_redirected_to applicants_path
  end
end
