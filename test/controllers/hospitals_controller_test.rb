# frozen_string_literal: true

require 'test_helper'

# Tests to make sure hospital lists can be maintained by administrators
class HospitalsControllerTest < ActionController::TestCase
  setup do
    login(users(:administrator))
    @hospital = hospitals(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:hospitals)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create hospital' do
    assert_difference('Hospital.count') do
      post :create, hospital: { name: 'Hospital A' }
    end

    assert_redirected_to hospital_path(assigns(:hospital))
  end

  test 'should show hospital' do
    get :show, id: @hospital
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @hospital
    assert_response :success
  end

  test 'should update hospital' do
    patch :update, id: @hospital, hospital: { name: 'Hospital A Updated' }
    assert_redirected_to hospital_path(assigns(:hospital))
  end

  test 'should destroy hospital' do
    assert_difference('Hospital.current.count', -1) do
      delete :destroy, id: @hospital
    end

    assert_redirected_to hospitals_path
  end
end
