# frozen_string_literal: true

require 'test_helper'

# Test to make sure devise emails generate correctly
class DeviseMailerTest < ActionMailer::TestCase
  test 'confirmation instructions email for applicant' do
    applicant = applicants(:one)
    email = Devise::Mailer.confirmation_instructions(applicant, 'faketoken').deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [applicant.email], email.to
    assert_equal 'Confirmation instructions', email.subject
    assert_match(%r{#{ENV['website_url']}/trainee/confirmation\?confirmation_token=faketoken}, email.encoded)
  end

  test 'confirmation instructions email for preceptor' do
    preceptor = preceptors(:one)
    email = Devise::Mailer.confirmation_instructions(preceptor, 'faketoken').deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [preceptor.email], email.to
    assert_equal 'Confirmation instructions', email.subject
    assert_match(%r{#{ENV['website_url']}/preceptor/confirmation\?confirmation_token=faketoken}, email.encoded)
  end

  # test 'confirmation instructions email for user' do
  #   valid = users(:valid)
  #   email = Devise::Mailer.confirmation_instructions(valid, 'faketoken').deliver_now
  #   assert !ActionMailer::Base.deliveries.empty?
  #   assert_equal [valid.email], email.to
  #   assert_equal 'Confirmation instructions', email.subject
  #   assert_match(%r{#{ENV['website_url']}/confirmation\?confirmation_token=faketoken}, email.encoded)
  # end

  test 'reset password email for applicant' do
    applicant = applicants(:one)
    email = Devise::Mailer.reset_password_instructions(applicant, 'faketoken').deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [applicant.email], email.to
    assert_equal 'Reset password instructions', email.subject
    assert_match(%r{#{ENV['website_url']}/trainee/password/edit\?reset_password_token=faketoken}, email.encoded)
  end

  test 'reset password email for preceptor' do
    preceptor = preceptors(:one)
    email = Devise::Mailer.reset_password_instructions(preceptor, 'faketoken').deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [preceptor.email], email.to
    assert_equal 'Reset password instructions', email.subject
    assert_match(%r{#{ENV['website_url']}/preceptor/password/edit\?reset_password_token=faketoken}, email.encoded)
  end

  test 'reset password email for user' do
    valid = users(:valid)
    email = Devise::Mailer.reset_password_instructions(valid, 'faketoken').deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [valid.email], email.to
    assert_equal 'Reset password instructions', email.subject
    assert_match(%r{#{ENV['website_url']}/password/edit\?reset_password_token=faketoken}, email.encoded)
  end

  test 'unlock instructions email for applicant' do
    applicant = applicants(:one)
    email = Devise::Mailer.unlock_instructions(applicant, 'faketoken').deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [applicant.email], email.to
    assert_equal 'Unlock Instructions', email.subject
    assert_match(%r{#{ENV['website_url']}/trainee/unlock\?unlock_token=faketoken}, email.encoded)
  end

  test 'unlock instructions email for preceptor' do
    preceptor = preceptors(:one)
    email = Devise::Mailer.unlock_instructions(preceptor, 'faketoken').deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [preceptor.email], email.to
    assert_equal 'Unlock Instructions', email.subject
    assert_match(%r{#{ENV['website_url']}/preceptor/unlock\?unlock_token=faketoken}, email.encoded)
  end

  # test 'unlock instructions email for user' do
  #   valid = users(:valid)

  #   email = Devise::Mailer.unlock_instructions(valid, 'faketoken').deliver_now
  #   assert !ActionMailer::Base.deliveries.empty?

  #   assert_equal [valid.email], email.to
  #   assert_equal 'Unlock Instructions', email.subject
  #   assert_match(%r{#{ENV['website_url']}/unlock\?unlock_token=faketoken}, email.encoded)
  # end
end
