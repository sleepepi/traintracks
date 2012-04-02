require 'test_helper'

class PreceptorsControllerTest < ActionController::TestCase
  setup do
    login(users(:valid))
    @preceptor = preceptors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:preceptors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create preceptor" do
    assert_difference('Preceptor.count') do
      post :create, preceptor: { degree: @preceptor.degree, deleted: @preceptor.deleted, first_name: @preceptor.first_name, hospital_affiliation: @preceptor.hospital_affiliation, hospital_appointment: @preceptor.hospital_appointment, last_name: @preceptor.last_name, other_support: @preceptor.other_support, program_role: @preceptor.program_role, rank: @preceptor.rank, research_interest: @preceptor.research_interest, status: @preceptor.status }
    end

    assert_redirected_to preceptor_path(assigns(:preceptor))
  end

  test "should show preceptor" do
    get :show, id: @preceptor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @preceptor
    assert_response :success
  end

  test "should update preceptor" do
    put :update, id: @preceptor, preceptor: { degree: @preceptor.degree, deleted: @preceptor.deleted, first_name: @preceptor.first_name, hospital_affiliation: @preceptor.hospital_affiliation, hospital_appointment: @preceptor.hospital_appointment, last_name: @preceptor.last_name, other_support: @preceptor.other_support, program_role: @preceptor.program_role, rank: @preceptor.rank, research_interest: @preceptor.research_interest, status: @preceptor.status }
    assert_redirected_to preceptor_path(assigns(:preceptor))
  end

  test "should destroy preceptor" do
    assert_difference('Preceptor.current.count', -1) do
      delete :destroy, id: @preceptor
    end

    assert_redirected_to preceptors_path
  end
end
