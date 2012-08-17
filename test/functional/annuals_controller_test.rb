require 'test_helper'

class AnnualsControllerTest < ActionController::TestCase
  setup do
    login(users(:administrator))
    @annual = annuals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:annuals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create annual" do
    assert_difference('Annual.count') do
      post :create, annual: { applicant_id: @annual.applicant_id, coursework_completed: @annual.coursework_completed, nih_other_support: @annual.nih_other_support, presentations: @annual.presentations, publications: @annual.publications, research_description: @annual.research_description, source_of_support: @annual.source_of_support, year: 2012 }
    end

    assert_redirected_to annual_path(assigns(:annual))
  end

  test "should show annual" do
    get :show, id: @annual
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @annual
    assert_response :success
  end

  test "should update annual" do
    put :update, id: @annual, annual: { applicant_id: @annual.applicant_id, coursework_completed: @annual.coursework_completed, nih_other_support: @annual.nih_other_support, presentations: @annual.presentations, publications: @annual.publications, research_description: @annual.research_description, source_of_support: @annual.source_of_support, year: 2012 }
    assert_redirected_to annual_path(assigns(:annual))
  end

  test "should destroy annual" do
    assert_difference('Annual.current.count', -1) do
      delete :destroy, id: @annual
    end

    assert_redirected_to annuals_path
  end
end
