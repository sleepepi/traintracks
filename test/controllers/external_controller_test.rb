# frozen_string_literal: true

require "test_helper"

# Tests to assure external pages are accessible.
class ExternalControllerTest < ActionDispatch::IntegrationTest
  test "should get privacy policy" do
    get privacy_policy_url
    assert_response :success
  end
end
