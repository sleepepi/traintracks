# frozen_string_literal: true

require "application_system_test_case"

# Test external pages.
class ExternalTest < ApplicationSystemTestCase
  test "visit the privacy policy page" do
    visit privacy_policy_url
    screenshot("visit-privacy-policy-page")
  end

  test "visit the version page" do
    visit version_url
    screenshot("visit-version-page")
  end
end
