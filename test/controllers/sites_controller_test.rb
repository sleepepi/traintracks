# frozen_string_literal: true

require 'test_helper'

# Tests to assure static pages can be viewed.
class SitesControllerTest < ActionController::TestCase
  test 'should get about' do
    get :about
    assert_response :success
  end

  test 'should get index' do
    login(users(:administrator))
    get :dashboard
    assert_response :success
  end

  test 'should get contact' do
    get :contact
    assert_response :success
  end

  test 'should get forgot my password' do
    get :forgot_my_password
    assert_response :success
  end

  test 'should get version' do
    get :version
    assert_response :success
  end

  test 'should get version as json' do
    get :version, format: 'json'
    version = JSON.parse(response.body)
    assert_equal TrainingGrant::VERSION::STRING, version['version']['string']
    assert_equal TrainingGrant::VERSION::MAJOR, version['version']['major']
    assert_equal TrainingGrant::VERSION::MINOR, version['version']['minor']
    assert_equal TrainingGrant::VERSION::TINY, version['version']['tiny']
    if TrainingGrant::VERSION::BUILD.nil?
      assert_nil version['version']['build']
    else
      assert_equal TrainingGrant::VERSION::BUILD, version['version']['build']
    end
    assert_response :success
  end
end
