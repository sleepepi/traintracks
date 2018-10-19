# frozen_string_literal: true

require "application_system_test_case"

# Test preceptor pages.
class PreceptorsTest < ApplicationSystemTestCase
  setup do
    @preceptor = preceptors(:one)
  end

  test "visit preceptor dashboard" do
    visit_login_as_preceptor(@preceptor, "visit-preceptor-dashboard")
    screenshot("visit-preceptor-dashboard")
    scroll_down
    screenshot("visit-preceptor-dashboard")
  end

  test "submit preceptor application" do
    visit_login_as_preceptor(@preceptor)
    screenshot("submit-preceptor-application")
    click_on("Edit my information")
    screenshot("submit-preceptor-application")
    attach_file(
      "preceptor[curriculum_vitae]",
      Rails.root.join(
        "test", "support", "applicants", "curriculum_vitae", "test_01.pdf"
      ),
      make_visible: true
    )
    screenshot("submit-preceptor-application")
    click_on "Update My Information"
    sleep 1 # Allow time to show flash notice.
    assert_text "Preceptor information successfully updated."
    assert_selector "h1", text: "Preceptor Dashboard"
    screenshot("submit-preceptor-application")
  end
end
