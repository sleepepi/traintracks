require 'test_helper'

class PreceptorsControllerTest < ActionController::TestCase
  setup do
    @preceptor = preceptors(:one)
  end

  test "should send notification email as administrator" do
    login(users(:administrator))
    post :email, id: @preceptor
    assert_redirected_to assigns(:preceptor)
  end

  test "should get csv as administrator" do
    login(users(:administrator))
    get :index, format: 'csv'
    assert_not_nil assigns(:csv_string)
    assert_response :success
  end

  # Currently no fixtures have enrolled trainees
  test "should not get csv if no preceptors are selected as administrator" do
    login(users(:administrator))
    get :index, format: 'csv', search: 'none'
    assert_nil assigns(:csv_string)
    assert_equal flash[:alert], 'No data was exported since no preceptors matched the specified filters.'
    assert_redirected_to preceptors_path
  end

  test "should get index as administrator" do
    login(users(:administrator))
    get :index
    assert_response :success
    assert_not_nil assigns(:preceptors)
  end

  test "should get new as administrator" do
    login(users(:administrator))
    get :new
    assert_response :success
  end

  test "should create preceptor as administrator" do
    login(users(:administrator))
    assert_difference('Preceptor.count') do
      post :create, preceptor: { first_name: "First Preceptor", last_name: "Last Preceptor", degree: @preceptor.degree, hospital_affiliation: @preceptor.hospital_affiliation, hospital_appointment: @preceptor.hospital_appointment, other_support: fixture_file_upload('../../test/support/applicants/curriculum_vitae/test_01.doc'), program_role: @preceptor.program_role, rank: @preceptor.rank, research_interest: @preceptor.research_interest, status: @preceptor.status, email: 'three@example.com', password: 'password', publications: 'Publications', grants: 'Grants' }
    end
    assert_not_nil assigns(:preceptor)
    assert_equal 'First Preceptor', assigns(:preceptor).first_name
    assert_equal 'Last Preceptor', assigns(:preceptor).last_name
    assert_equal 'Grants', assigns(:preceptor).grants
    assert_equal 'Publications', assigns(:preceptor).publications
    assert_redirected_to preceptor_path(assigns(:preceptor))
  end

  test "should not create preceptor with blank name as administrator" do
    login(users(:administrator))
    assert_difference('Preceptor.count', 0) do
      post :create, preceptor: { first_name: "", last_name: "", degree: @preceptor.degree, hospital_affiliation: @preceptor.hospital_affiliation, hospital_appointment: @preceptor.hospital_appointment, other_support: fixture_file_upload('../../test/support/applicants/curriculum_vitae/test_01.doc'), program_role: @preceptor.program_role, rank: @preceptor.rank, research_interest: @preceptor.research_interest, status: @preceptor.status, email: 'three@example.com', password: 'password', publications: 'Publications', grants: 'Grants' }
    end
    assert_not_nil assigns(:preceptor)
    assert assigns(:preceptor).errors.size > 0
    assert_equal ["can't be blank"], assigns(:preceptor).errors[:first_name]
    assert_equal ["can't be blank"], assigns(:preceptor).errors[:last_name]
    assert_template 'new'
  end

  test "should show preceptor as administrator" do
    login(users(:administrator))
    get :show, id: @preceptor
    assert_response :success
  end

  test "should get edit as administrator" do
    login(users(:administrator))
    get :edit, id: @preceptor
    assert_response :success
  end

  test "should update preceptor as administrator" do
    login(users(:administrator))
    put :update, id: @preceptor, preceptor: { first_name: "First Updated", last_name: "Last Updated", degree: @preceptor.degree, hospital_affiliation: @preceptor.hospital_affiliation, hospital_appointment: @preceptor.hospital_appointment, other_support: fixture_file_upload('../../test/support/applicants/curriculum_vitae/test_01.doc'), program_role: @preceptor.program_role, rank: @preceptor.rank, research_interest: @preceptor.research_interest, status: @preceptor.status, email: @preceptor.email, publications: 'Publications', grants: 'Grants' }

    assert_not_nil assigns(:preceptor)
    assert_equal 'First Updated', assigns(:preceptor).first_name
    assert_equal 'Last Updated', assigns(:preceptor).last_name
    assert_equal 'Grants', assigns(:preceptor).grants
    assert_equal 'Publications', assigns(:preceptor).publications

    assert_redirected_to preceptor_path(assigns(:preceptor))
  end

  test "should not update preceptor with blank name as administrator" do
    login(users(:administrator))
    put :update, id: @preceptor, preceptor: { first_name: "", last_name: "", degree: @preceptor.degree, hospital_affiliation: @preceptor.hospital_affiliation, hospital_appointment: @preceptor.hospital_appointment, other_support: fixture_file_upload('../../test/support/applicants/curriculum_vitae/test_01.doc'), program_role: @preceptor.program_role, rank: @preceptor.rank, research_interest: @preceptor.research_interest, status: @preceptor.status, email: @preceptor.email, publications: 'Publications', grants: 'Grants' }
    assert_not_nil assigns(:preceptor)
    assert assigns(:preceptor).errors.size > 0
    assert_equal ["can't be blank"], assigns(:preceptor).errors[:first_name]
    assert_equal ["can't be blank"], assigns(:preceptor).errors[:last_name]
    assert_template 'edit'
  end

  test "should destroy preceptor as administrator" do
    login(users(:administrator))
    assert_difference('Preceptor.current.count', -1) do
      delete :destroy, id: @preceptor
    end

    assert_redirected_to preceptors_path
  end

  test "should get dashboard as preceptor" do
    login(preceptors(:one))
    get :dashboard
    assert_response :success
  end

  test "should edit me as preceptor" do
    login(preceptors(:one))
    get :edit_me
    assert_response :success
  end

  test "should update me as preceptor" do
    login(preceptors(:one))
    put :update_me, preceptor: { first_name: "My First Name", last_name: "My Last Name", degree: @preceptor.degree, hospital_affiliation: @preceptor.hospital_affiliation, hospital_appointment: @preceptor.hospital_appointment, other_support: @preceptor.other_support, program_role: @preceptor.program_role, rank: @preceptor.rank, research_interest: @preceptor.research_interest, status: @preceptor.status, email: @preceptor.email, publications: 'Publications', grants: 'Grants' }
    preceptors(:one).reload
    assert_equal 'My First Name', preceptors(:one).first_name
    assert_equal 'My Last Name', preceptors(:one).last_name
    assert_equal 'Grants', preceptors(:one).grants
    assert_equal 'Publications', preceptors(:one).publications
    assert_equal 'Preceptor information successfully updated.', flash[:notice]
    assert_redirected_to dashboard_preceptors_path
  end

  test "should not update me with blank name as preceptor" do
    login(preceptors(:one))
    put :update_me, preceptor: { first_name: "", last_name: "", degree: @preceptor.degree, hospital_affiliation: @preceptor.hospital_affiliation, hospital_appointment: @preceptor.hospital_appointment, other_support: @preceptor.other_support, program_role: @preceptor.program_role, rank: @preceptor.rank, research_interest: @preceptor.research_interest, status: @preceptor.status, email: @preceptor.email, publications: 'Publications', grants: 'Grants' }
    assert_template 'edit_me'
  end
end
