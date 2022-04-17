# frozen_string_literal: true

require 'test_helper'

# Tests to make sure that annual information can be edited by administrator.
class AnnualsControllerTest < ActionController::TestCase
  setup do
    @annual = annuals(:one)
    @administrator = users(:administrator)
    @applicant = applicants(:one)
  end

  def degree_hashes
    [
      {
        degree_type: 'mams',
        institution: 'Online School',
        year: '2016',
        advisor: 'Advisor',
        thesis: 'Thesis',
        concentration_major: 'Computer Science'
      },
      {
        degree_type: 'babs',
        institution: 'Institution',
        year: '2010',
        advisor: '',
        thesis: '',
        concentration_major: ''
      }
    ]
  end

  def applicant_params
    {
      # Contact Information
      phone: @applicant.phone,
      address1: @applicant.address1,
      address2: @applicant.address2,
      city: @applicant.city,
      state: @applicant.state,
      country: @applicant.country,
      zip_code: @applicant.zip_code,
      # Education
      curriculum_vitae: fixture_file_upload('../../support/applicants/curriculum_vitae/test_01.pdf'),
      current_institution: @applicant.current_institution,
      department_program: @applicant.department_program,
      current_position: @applicant.current_position,
      degree_hashes: degree_hashes,
      degree_sought: @applicant.degree_sought,
      expected_year: @applicant.expected_year,
      residency: @applicant.residency,
      research_interests: @applicant.research_interests,
      preferred_preceptor_id: @applicant.preferred_preceptor_id,
      preferred_preceptor_two_id: @applicant.preferred_preceptor_two_id,
      preferred_preceptor_three_id: @applicant.preferred_preceptor_three_id,
      previous_nrsa_support: @applicant.previous_nrsa_support,
    }
  end

  def annual_params
    {
      applicant_id: @annual.applicant_id,
      coursework_completed: @annual.coursework_completed,
      nih_other_support: @annual.nih_other_support,
      presentations: @annual.presentations,
      publications: @annual.publications,
      research_description: @annual.research_description,
      source_of_support: @annual.source_of_support,
      year: 2012
    }
  end

  test 'should get csv' do
    login(@administrator)
    get :index, format: 'csv'
    assert_not_nil assigns(:csv_string)
    assert_response :success
  end

  # Currently no annuals are found for 'aaa'
  test 'should not get csv if no annuals are selected' do
    login(@administrator)
    get :index, params: { search: 'aaa' }, format: 'csv'
    assert_nil assigns(:csv_string)
    assert_equal flash[:alert], 'No data was exported since no applicants matched the specified filters.'
    assert_redirected_to annuals_path
  end

  test 'should get index' do
    login(@administrator)
    get :index
    assert_response :success
    assert_not_nil assigns(:annuals)
  end

  test 'should get new' do
    login(@administrator)
    get :new
    assert_response :success
  end

  test 'should create annual' do
    login(@administrator)
    assert_difference('Annual.count') do
      post :create, params: { annual: annual_params }
    end
    assert_redirected_to annual_path(assigns(:annual))
  end

  test 'should show annual' do
    login(@administrator)
    get :show, params: { id: @annual }
    assert_response :success
  end

  test 'should get edit' do
    login(@administrator)
    get :edit, params: { id: @annual }
    assert_response :success
  end

  test 'should update annual' do
    login(@administrator)
    patch :update, params: { id: @annual, annual: annual_params }
    assert_redirected_to annual_path(assigns(:annual))
  end

  test 'should destroy annual' do
    login(@administrator)
    assert_difference('Annual.current.count', -1) do
      delete :destroy, params: { id: @annual }
    end
    assert_redirected_to annuals_path
  end

  test 'should get annual edit for applicant' do
    login(@applicant)
    get :edit_me, params: { id: @annual }
    assert_response :success
  end

  test 'should update annual for applicant' do
    login(@applicant)
    patch :update_me, params: {
      id: @annual,
      applicant: applicant_params.merge(publish_annual: '1'),
      annual: annual_params
    }
    assert_not_nil assigns(:annual)
    assert_redirected_to dashboard_applicants_path
  end

  test 'should not update annual for applicant with blank name' do
    login(@applicant)
    patch :update_me, params: {
      id: @annual,
      applicant: applicant_params.merge(publish_annual: '1', phone: ''),
      annual: annual_params
    }
    assert_not_nil assigns(:annual)
    assert_template 'edit_me'
    assert_response :success
  end

  test 'should not update annual for applicant without valid id' do
    login(@applicant)
    patch :update_me, params: {
      id: -1,
      applicant: applicant_params.merge(publish_annual: '1'),
      annual: annual_params
    }
    assert_nil assigns(:annual)
    assert_redirected_to dashboard_applicants_path
  end
end
