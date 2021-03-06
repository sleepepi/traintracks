# frozen_string_literal: true

require 'test_helper'

# Tests to make sure seminars can be viewed and updated by administrators.
class SeminarsControllerTest < ActionController::TestCase
  setup do
    login(users(:administrator))
    @seminar = seminars(:one)
  end

  test 'should get attendance' do
    get :attendance
    assert_not_nil assigns(:applicants)
    assert_not_nil assigns(:seminars)
    assert_not_nil assigns(:year)
    assert_nil assigns(:csv_string)
    assert_response :success
  end

  test 'should get attendance csv' do
    get :attendance, format: 'csv'
    assert_not_nil assigns(:applicants)
    assert_not_nil assigns(:seminars)
    assert_not_nil assigns(:year)
    assert_not_nil assigns(:csv_string)
    assert_response :success
  end

  test 'should get attendance with year and status specified' do
    get :attendance, params: { year: '2013', status: 'current' }
    assert_not_nil assigns(:applicants)
    assert_not_nil assigns(:seminars)
    assert_not_nil assigns(:year)
    assert_nil assigns(:csv_string)
    assert_response :success
  end

  test 'should mark attendance as attended' do
    post :attended, params: {
      id: @seminar, attended: '1', applicant_id: applicants(:one).id
    }, format: 'js'
    assert_not_nil assigns(:seminar)
    assert_not_nil assigns(:applicant)
    assert_equal 1, assigns(:applicant).seminars.where(id: @seminar.id).count
    assert_template 'attended'
    assert_response :success
  end

  test 'should mark attendance as not attended' do
    post :attended, params: {
      id: @seminar, attended: '0', applicant_id: applicants(:two).id
    }, format: 'js'
    assert_not_nil assigns(:seminar)
    assert_not_nil assigns(:applicant)
    assert_equal 0, assigns(:applicant).seminars.where(id: @seminar.id).count
    assert_template 'attended'
    assert_response :success
  end

  test 'should not mark attendance with invalid applicant' do
    post :attended, params: {
      id: @seminar, attended: '1', applicant_id: -1
    }, format: 'js'
    assert_not_nil assigns(:seminar)
    assert_nil assigns(:applicant)
    assert_response :success
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:seminars)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create seminar' do
    assert_difference('Seminar.count') do
      post :create, params: {
        seminar: {
          category: @seminar.category,
          duration: @seminar.duration,
          duration_units: @seminar.duration_units,
          presentation_date: @seminar.presentation_date,
          presentation_title: @seminar.presentation_title,
          presenter: @seminar.presenter
        }
      }
    end
    assert_redirected_to seminar_path(assigns(:seminar))
  end

  test 'should show seminar' do
    get :show, params: { id: @seminar }
    assert_response :success
  end

  test 'should show seminar with no presentation date' do
    get :show, params: { id: seminars(:no_date) }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @seminar }
    assert_response :success
  end

  test 'should update seminar' do
    patch :update, params: {
      id: @seminar,
      seminar: {
        category: @seminar.category,
        duration: @seminar.duration,
        duration_units: @seminar.duration_units,
        presentation_date: @seminar.presentation_date,
        presentation_title: @seminar.presentation_title,
        presenter: @seminar.presenter
      }
    }
    assert_redirected_to seminar_path(assigns(:seminar))
  end

  test 'should destroy seminar' do
    assert_difference('Seminar.current.count', -1) do
      delete :destroy, params: { id: @seminar }
    end
    assert_redirected_to seminars_path
  end
end
