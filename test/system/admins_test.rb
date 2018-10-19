# frozen_string_literal: true

require "application_system_test_case"

# Test system admin pages.
class AdminsTest < ApplicationSystemTestCase
  setup do
    @admin = users(:admin)
  end

  test "visit admin dashboard" do
    visit_login_as_user(@admin, "visit-admin-dashboard")
    screenshot("visit-admin-dashboard")
  end
end
