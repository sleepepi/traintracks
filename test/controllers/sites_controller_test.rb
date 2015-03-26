require 'test_helper'

class SitesControllerTest < ActionController::TestCase

  setup do
    # Nothing
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get index" do
    login(users(:administrator))
    get :dashboard
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

  test "should get forgot my password" do
    get :forgot_my_password
    assert_response :success
  end

end
