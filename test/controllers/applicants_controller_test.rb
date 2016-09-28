# frozen_string_literal: true

require 'test_helper'

# Tests to make sure that applicant information can be viewed and updated by
# administrators.
class ApplicantsControllerTest < ActionController::TestCase
  setup do
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
      # Basic Information
      email: @applicant.email,
      first_name: @applicant.first_name,
      last_name: @applicant.last_name,
      middle_initial: @applicant.middle_initial,
      applicant_type: @applicant.applicant_type,
      desired_start_date: '8/28/2012',
      personal_statement: @applicant.personal_statement,
      alien_registration_number: @applicant.alien_registration_number,
      citizenship_status: @applicant.citizenship_status,
      # Contact Information
      phone: @applicant.phone,
      address1: @applicant.address1,
      address2: @applicant.address2,
      city: @applicant.city,
      state: @applicant.state,
      country: @applicant.country,
      zip_code: @applicant.zip_code,
      # Education
      curriculum_vitae: fixture_file_upload('../../test/support/applicants/curriculum_vitae/test_01.pdf'),
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
      # Demographic Information
      gender: @applicant.gender,
      disabled: @applicant.disabled,
      disadvantaged: @applicant.disadvantaged,
      urm: @applicant.urm,
      urm_types: @applicant.urm_types,
      marital_status: @applicant.marital_status,
      # Applicant Assurance
      letters_from_a: @applicant.letters_from_a,
      letters_from_b: @applicant.letters_from_b,
      letters_from_c: @applicant.letters_from_c,
      assurance: @applicant.assurance,
      # Administrator Only
      reviewed: @applicant.reviewed,
      review_date: '1/30/2012',
      offered: @applicant.offered,
      accepted: @applicant.accepted,
      enrolled: @applicant.enrolled,
      cv_number: @applicant.cv_number,
      degree_type: @applicant.degree_type,
      trainee_code: @applicant.trainee_code,
      status: @applicant.status,
      training_grant_years: @applicant.training_grant_years,
      supported_by_tg: @applicant.supported_by_tg,
      training_period_start_date: '2/10/2012',
      training_period_end_date: '2/10/2013',
      notes: @applicant.notes,
      primary_preceptor_id: @applicant.primary_preceptor_id,
      secondary_preceptor_id: @applicant.secondary_preceptor_id

      # Unused from admin update
      # research_project_title: @applicant.research_project_title,
      # tge: @applicant.tge, email: 'three@example.com', password: 'password'
    }
  end

  test 'should get csv' do
    login(@administrator)
    get :index, format: 'csv'
    assert_not_nil assigns(:csv_string)
    assert_response :success
  end

  # Currently no fixtures have enrolled trainees
  test 'should not get csv if no applicants are selected' do
    login(@administrator)
    get :index, params: { enrolled: 'except' }, format: 'csv'
    assert_nil assigns(:csv_string)
    assert_equal flash[:alert], 'No data was exported since no applicants matched the specified filters.'
    assert_redirected_to applicants_path
  end

  test 'should send annual reminder email' do
    login(@administrator)
    post :send_annual_reminder_email, params: {
      year: '2001', subject: 'Subject', body: 'Body'
    }
    assert_equal "Annual Reminder email successfully sent to #{Applicant.supported_by_tg_in_last_fifteen_years.count} applicants.", flash[:notice]
    assert_redirected_to applicants_path
  end

  test 'should send annual reminder email to individual applicant' do
    login(@administrator)
    post :send_annual_reminder_email, params: {
      year: '2001', subject: 'Subject', body: 'Body', applicant_id: applicants(:one).id
    }
    assert_equal "Annual Reminder email successfully sent to #{applicants(:one).name}.", flash[:notice]
    assert_redirected_to applicants(:one)
  end

  test 'should not send annual reminder email with year less than 2001' do
    login(@administrator)
    post :send_annual_reminder_email, params: {
      year: '2000', subject: 'Subject', body: 'Body'
    }
    assert_equal "'2000' is not a valid year.", flash[:alert]
    assert_redirected_to applicants_path
  end

  test 'should get program requirements' do
    login(@administrator)
    get :program_requirements
    assert_response :success
    assert_not_nil assigns(:applicants)
  end

  test 'should get csv of program requirements' do
    login(@administrator)
    get :program_requirements, format: 'csv'
    assert_not_nil assigns(:csv_string)
    assert_response :success
  end

  test 'should get index' do
    login(@administrator)
    get :index
    assert_response :success
    assert_not_nil assigns(:applicants)
  end

  test 'should get new' do
    login(@administrator)
    get :new
    assert_response :success
  end

  test 'should create applicant' do
    login(@administrator)
    assert_difference('Applicant.count') do
      post :create, params: {
        applicant: applicant_params.merge(email: 'new@example.com')
      }
    end
    assert_redirected_to applicant_path(assigns(:applicant))
  end

  test 'should create applicant and add era commons username' do
    login(@administrator)
    assert_difference('Applicant.count') do
      post :create, params: {
        applicant: applicant_params.merge(email: 'era@example.com', era_commons_username: 'MYERACOMMONSNAME')
      }
    end
    assert_not_nil assigns(:applicant)
    assert_equal 'MYERACOMMONSNAME', assigns(:applicant).era_commons_username
    assert_redirected_to applicant_path(assigns(:applicant))
  end

  test 'should show applicant' do
    login(@administrator)
    get :show, params: { id: @applicant }
    assert_response :success
  end

  test 'should get edit' do
    login(@administrator)
    get :edit, params: { id: @applicant }
    assert_response :success
  end

  test 'should update applicant' do
    login(@administrator)
    patch :update, params: { id: @applicant, applicant: applicant_params }
    assert_redirected_to @applicant
  end

  test 'should update applicant with blank email' do
    login(@administrator)
    patch :update, params: {
      id: @applicant, applicant: applicant_params.merge(email: '')
    }
    assert_not_nil assigns(:applicant)
    assert_equal '', assigns(:applicant).email
    assert_redirected_to @applicant
  end

  test 'should update applicant serializable attributes' do
    login(@administrator)
    patch :update, params: {
      id: @applicant, applicant: applicant_params.merge(
        urm_types: ['nativehawaiian pacific_islander', 'black africanamerica'],
        laboratories: ['basic science', 'clinical science'],
        transition_position: ['private practice'],
        research_interests: ['human physiology', 'circadian chronobiology'],
        degree_hashes: degree_hashes
      ),
      set_urm_types: '1', set_laboratories: '1', set_transition_position: '1',
      set_research_interests: '1', set_degree_hashes: '1'
    }
    assert_not_nil assigns(:applicant)
    assert_equal ['black africanamerica', 'nativehawaiian pacific_islander'], assigns(:applicant).urm_types.sort
    assert_equal ['basic science', 'clinical science'], assigns(:applicant).laboratories.sort
    assert_equal ['private practice'], assigns(:applicant).transition_position.sort
    assert_equal ['circadian chronobiology', 'human physiology'], assigns(:applicant).research_interests.sort
    first_degree = assigns(:applicant).degrees.first
    second_degree = assigns(:applicant).degrees.second
    assert_equal 'mams', first_degree.degree_type
    assert_equal 'Online School', first_degree.institution
    assert_equal 2016, first_degree.year
    assert_equal 'Advisor', first_degree.advisor
    assert_equal 'Thesis', first_degree.thesis
    assert_equal 'Computer Science', first_degree.concentration_major
    assert_equal 'babs', second_degree.degree_type
    assert_equal 'Institution', second_degree.institution
    assert_equal 2010, second_degree.year
    assert_equal '', second_degree.advisor
    assert_equal '', second_degree.thesis
    assert_equal '', second_degree.concentration_major
    assert_redirected_to @applicant
  end

  test 'should update applicant and clear serializable attributes' do
    login(@administrator)
    patch :update, params: {
      id: @applicant, applicant: { }, set_urm_types: '1',
      set_laboratories: '1', set_transition_position: '1',
      set_research_interests: '1', set_degree_hashes: '1'
    }
    assert_not_nil assigns(:applicant)
    assert_equal [], assigns(:applicant).urm_types
    assert_equal [], assigns(:applicant).laboratories
    assert_equal [], assigns(:applicant).transition_position
    assert_equal [], assigns(:applicant).research_interests
    assert_equal [], assigns(:applicant).degrees
    assert_redirected_to @applicant
  end

  test 'should destroy applicant' do
    login(@administrator)
    assert_difference('Applicant.current.count', -1) do
      delete :destroy, params: { id: @applicant }
    end
    assert_redirected_to applicants_path
  end

  test 'should get dashboard' do
    login(@applicant)
    get :dashboard
    assert_response :success
  end

  test 'should edit me' do
    login(@applicant)
    get :edit_me
    assert_response :success
  end

  test 'should update me and save draft' do
    login(@applicant)
    patch :update_me, params: { applicant: applicant_params.merge(publish: '0') }
    assert_equal [], @controller.current_applicant.errors.full_messages
    assert_equal 'Application successfully updated.', flash[:notice]
    assert_redirected_to dashboard_applicants_path
  end

  test 'should not update me with blank degree hashes' do
    login(@applicant)
    patch :update_me, params: {
      applicant: applicant_params.merge(
        publish: '1',
        degree_hashes: [{ degree_type: '', institution: '', year: '' }]
      )
    }
    assert_equal ["degree type can't be blank", "institution can't be blank", "year can't be blank"], @controller.current_applicant.errors[:degrees]
    assert_template 'edit_me'
    assert_response :success
  end

  test 'should update me and publish with CV as PDF' do
    login(@applicant)
    patch :update_me, params: { applicant: applicant_params.merge(publish: '1') }
    assert_equal [], @controller.current_applicant.errors.full_messages
    assert_equal 'Application successfully updated.', flash[:notice]
    assert_redirected_to dashboard_applicants_path
  end

  test 'should update me and publish with CV as DOC' do
    login(@applicant)
    patch :update_me, params: {
      applicant: applicant_params.merge(
        publish: '1',
        curriculum_vitae: fixture_file_upload('../../test/support/applicants/curriculum_vitae/test_01.doc')
      )
    }
    assert_equal [], @controller.current_applicant.errors.full_messages
    assert_equal 'Application successfully updated.', flash[:notice]
    assert_redirected_to dashboard_applicants_path
  end

  test 'should update me and publish with CV as DOCX' do
    login(@applicant)
    patch :update_me, params: {
      applicant: applicant_params.merge(
        publish: '1',
        curriculum_vitae: fixture_file_upload('../../test/support/applicants/curriculum_vitae/test_01.docx')
      )
    }
    assert_equal [], @controller.current_applicant.errors.full_messages
    assert_equal 'Application successfully updated.', flash[:notice]
    assert_redirected_to dashboard_applicants_path
  end

  test 'should send general update email to applicant' do
    login(@administrator)
    post :email, params: { id: @applicant }, format: 'js'
    assert_not_nil assigns(:applicant)
    assert_redirected_to @applicant
  end

  test 'should send annual reminder email to applicant' do
    login(@administrator)
    get :annual_email, params: { id: @applicant, annual_year: 2016, annual_subject: 'ACTION REQUIRED: Data Update', annual_body: 'You are being contacted' }, xhr: true, format: 'js'
    assert_not_nil assigns(:applicant)
    assert_template 'annual_email'
    assert_response :success
  end

  test 'should send termination email to applicant' do
    login(@administrator)
    post :termination_email, params: { id: @applicant }, format: 'js'
    assert_not_nil assigns(:applicant)
    assert_redirected_to @applicant
  end
end
