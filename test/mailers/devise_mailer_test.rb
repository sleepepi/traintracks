# frozen_string_literal: true

require "test_helper"

# Test to make sure devise emails generate correctly
class DeviseMailerTest < ActionMailer::TestCase
  test "confirmation instructions email for applicant" do
    applicant = applicants(:one)
    mail = Devise::Mailer.confirmation_instructions(applicant, "faketoken")
    assert_equal [applicant.email], mail.to
    assert_equal "Confirm your Train Tracks email address", mail.subject
    assert_match(%r{#{ENV["website_url"]}/trainee/confirmation\?confirmation_token=faketoken}, mail.body.encoded)
  end

  test "confirmation instructions email for preceptor" do
    preceptor = preceptors(:one)
    mail = Devise::Mailer.confirmation_instructions(preceptor, "faketoken")
    assert_equal [preceptor.email], mail.to
    assert_equal "Confirm your Train Tracks email address", mail.subject
    assert_match(%r{#{ENV["website_url"]}/preceptor/confirmation\?confirmation_token=faketoken}, mail.body.encoded)
  end

  # test "confirmation instructions email for user" do
  #   valid = users(:valid)
  #   mail = Devise::Mailer.confirmation_instructions(valid, "faketoken")
  #   assert_equal [valid.email], mail.to
  #   assert_equal "Confirmation instructions", mail.subject
  #   assert_match(%r{#{ENV["website_url"]}/confirmation\?confirmation_token=faketoken}, mail.body.encoded)
  # end

  test "reset password email for applicant" do
    applicant = applicants(:one)
    mail = Devise::Mailer.reset_password_instructions(applicant, "faketoken")
    assert_equal [applicant.email], mail.to
    assert_equal "Reset password for your Train Tracks account", mail.subject
    assert_match(%r{#{ENV["website_url"]}/trainee/password/edit\?reset_password_token=faketoken}, mail.body.encoded)
  end

  test "reset password email for preceptor" do
    preceptor = preceptors(:one)
    mail = Devise::Mailer.reset_password_instructions(preceptor, "faketoken")
    assert_equal [preceptor.email], mail.to
    assert_equal "Reset password for your Train Tracks account", mail.subject
    assert_match(%r{#{ENV["website_url"]}/preceptor/password/edit\?reset_password_token=faketoken}, mail.body.encoded)
  end

  test "reset password email for user" do
    valid = users(:valid)
    mail = Devise::Mailer.reset_password_instructions(valid, "faketoken")
    assert_equal [valid.email], mail.to
    assert_equal "Reset password for your Train Tracks account", mail.subject
    assert_match(%r{#{ENV["website_url"]}/password/edit\?reset_password_token=faketoken}, mail.body.encoded)
  end

  test "unlock instructions email for applicant" do
    applicant = applicants(:one)
    mail = Devise::Mailer.unlock_instructions(applicant, "faketoken")
    assert_equal [applicant.email], mail.to
    assert_equal "Unlock your Train Tracks account", mail.subject
    assert_match(%r{#{ENV["website_url"]}/trainee/unlock\?unlock_token=faketoken}, mail.body.encoded)
  end

  test "unlock instructions email for preceptor" do
    preceptor = preceptors(:one)
    mail = Devise::Mailer.unlock_instructions(preceptor, "faketoken")
    assert_equal [preceptor.email], mail.to
    assert_equal "Unlock your Train Tracks account", mail.subject
    assert_match(%r{#{ENV["website_url"]}/preceptor/unlock\?unlock_token=faketoken}, mail.body.encoded)
  end

  # test "unlock instructions email for user" do
  #   valid = users(:valid)
  #   mail = Devise::Mailer.unlock_instructions(valid, "faketoken")
  #   assert_equal [valid.email], mail.to
  #   assert_equal "Unlock Instructions", mail.subject
  #   assert_match(%r{#{ENV["website_url"]}/unlock\?unlock_token=faketoken}, mail.body.encoded)
  # end
end
