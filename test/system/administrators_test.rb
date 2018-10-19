# frozen_string_literal: true

require "application_system_test_case"

# Test administrator pages.
class AdministratorsTest < ApplicationSystemTestCase
  setup do
    @administrator = users(:administrator)
  end

  test "visit preceptors index" do
    visit_login_as_user(@administrator)
    click_on "Preceptors"
    screenshot("visit-preceptors-index")
    assert_selector "h1", text: "Preceptors"
  end

  test "visit preceptor page" do
    visit_login_as_user(@administrator)
    click_on "Preceptors"
    screenshot("visit-preceptor-page")
    click_on "John Locke"
    assert_selector "h1", text: "John Locke"
    screenshot("visit-preceptor-page")
    scroll_down
    screenshot("visit-preceptor-page")
  end

  test "visit applicants index" do
    visit_login_as_user(@administrator)
    click_on "Applicants"
    screenshot("visit-applicants-index")
    assert_selector "h1", text: "Applicants"
  end

  test "visit applicant page" do
    visit_login_as_user(@administrator)
    click_on "Applicants"
    screenshot("visit-applicant-page")
    click_on "FirstName MI LastName"
    assert_selector "h1", text: "FirstName MI LastName"
    screenshot("visit-applicant-page")
    scroll_down
    screenshot("visit-applicant-page")
  end

  test "visit annuals index" do
    visit_login_as_user(@administrator)
    click_on "Annual Information"
    screenshot("visit-annuals-index")
    assert_selector "h1", text: "Annuals"
  end

  test "visit seminars index" do
    visit_login_as_user(@administrator)
    click_on "Seminars"
    screenshot("visit-seminars-index")
    assert_selector "h1", text: "Seminars"
  end

  test "visit program requirements" do
    visit_login_as_user(@administrator)
    click_on "Program Requirements"
    screenshot("visit-program-requirements")
    assert_selector "h1", text: "Program Requirements"
  end
end
