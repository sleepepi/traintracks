# frozen_string_literal: true

require "application_system_test_case"

# Test applicant pages.
class ApplicantsTest < ApplicationSystemTestCase
  setup do
    @applicant = applicants(:one)
  end

  test "register as applicant" do
    visit new_applicant_registration_url
    fill_in "applicant[first_name]", with: "Joe"
    fill_in "applicant[last_name]", with: "Schmoe"
    fill_in "applicant[email]", with: "jschmoe@example.com"
    fill_in "applicant[password]", with: "1234567890"
    screenshot("register-as-applicant")
    click_on("Next step")
    assert_selector "h1", text: "Welcome to Train Tracks!"
    screenshot("register-as-applicant")
  end

  test "visit applicant dashboard" do
    visit_login_as_applicant(@applicant, "visit-applicant-dashboard")
    screenshot("visit-applicant-dashboard")
    scroll_down
    screenshot("visit-applicant-dashboard")
    scroll_down
    screenshot("visit-applicant-dashboard")
    scroll_down
    screenshot("visit-applicant-dashboard")
    scroll_down
    screenshot("visit-applicant-dashboard")
  end

  test "submit applicant application" do
    visit_login_as_applicant(@applicant)
    screenshot("submit-applicant-application")
    click_on("Edit Application")
    screenshot("submit-applicant-application")
    scroll_down
    screenshot("submit-applicant-application")
    attach_file(
      "applicant[curriculum_vitae]",
      Rails.root.join(
        "test", "support", "applicants", "curriculum_vitae", "test_01.pdf"
      ),
      make_visible: true
    )
    screenshot("submit-applicant-application")
    page.accept_confirm do
      click_on "Submit Application for Review"
    end
    sleep 1 # Allow time to show flash notice.
    assert_text "Application successfully updated."
    assert_selector "h1", text: "Congratulations!"
    screenshot("submit-applicant-application")
  end

  test "applicant help email" do
    visit_login_as_applicant(@applicant)
    screenshot("applicant-help-email")
    click_on("Help")
    screenshot("applicant-help-email")
    fill_in "body", with: "I don't know where to start.\n\nPlease send help.\n\nThanks!"
    screenshot("applicant-help-email")
    click_on("Send Email")
    sleep 1 # Allow time to show flash notice.
    assert_text "Help request submitted successfully."
    assert_selector "h1", text: "Applicant/Trainee Dashboard"
    screenshot("applicant-help-email")
  end

  test "submit applicant annual" do
    visit_login_as_applicant(@applicant)
    screenshot("submit-applicant-annual")
    click_on("Year 2010")
    screenshot("submit-applicant-annual")
    scroll_down
    screenshot("submit-applicant-annual")
    # fill_in "body", with: "I don't know where to start.\n\nPlease send help.\n\nThanks!"
    attach_file(
      "applicant[curriculum_vitae]",
      Rails.root.join(
        "test", "support", "applicants", "curriculum_vitae", "test_01.pdf"
      ),
      make_visible: true
    )
    screenshot("submit-applicant-annual")
    click_on "Submit Annual Information"
    sleep 1 # Allow time to show flash notice.
    assert_text "Annual information was successfully updated."
    assert_selector "h1", text: "Applicant/Trainee Dashboard"
    screenshot("submit-applicant-annual")
  end
end
