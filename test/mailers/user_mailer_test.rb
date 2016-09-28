# frozen_string_literal: true

require 'test_helper'

# Tests that mail views are rendered corretly, sent to correct user, and have a
# correct subject line.
class UserMailerTest < ActionMailer::TestCase
  test 'notify system admin email' do
    valid = users(:valid)
    admin = users(:admin)
    # Send the email, then test that it got queued
    email = UserMailer.notify_system_admin(admin, valid).deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    # Test the body of the sent email contains what we expect it to
    assert_equal [admin.email], email.to
    assert_equal "#{valid.name} Signed Up", email.subject
    assert_match(
      /#{valid.name} \[#{valid.email}\] signed up for an account\./,
      email.encoded
    )
  end

  test 'status activated email' do
    valid = users(:valid)
    # Send the email, then test that it got queued
    email = UserMailer.status_activated(valid).deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    # Test the body of the sent email contains what we expect it to
    assert_equal [valid.email], email.to
    assert_equal "#{valid.name}'s Account Activated", email.subject
    assert_match(
      /Your account \[#{valid.email}\] has been activated\./,
      email.encoded
    )
  end

  test 'annual submitted email' do
    annual = annuals(:one)
    email = UserMailer.annual_submitted(annual).deliver_now
    assert_equal 'FirstName MyString LastName Submitted Annual Update', email.subject
    assert_match(/FirstName MyString LastName has submitted a profile update\./, email.encoded)
  end

  test 'help email' do
    applicant = applicants(:one)
    # Send the email, then test that it got queued
    email = UserMailer.help_email(applicant, 'Help Me With...', 'Body').deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    # Test the body of the sent email contains what we expect it to
    assert_equal ['applicant_one@example.com'], email.reply_to
    assert_equal 'Help Me With... - FirstName MyString LastName', email.subject
    assert_match(/Body/, email.encoded)
  end

  test 'seminars reminder email' do
    applicant = applicants(:one)
    seminars = users(:valid).seminars
    # Send the email, then test that it got queued
    email = UserMailer.seminars_reminder(applicant, seminars).deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    # Test the body of the sent email contains what we expect it to
    assert_equal ['applicant_one@example.com'], email.to
    assert_equal 'Upcoming Seminars Reminder', email.subject
    assert_match(/Upcoming Seminars/, email.encoded)
  end

  test 'update application email' do
    applicant = applicants(:one)
    user = users(:valid)
    email = UserMailer.update_application(applicant, user).deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [applicant.email], email.to
    assert_equal 'Please Update Your Application Information', email.subject
    assert_match(
      /#{user.name} has requested that you update your application information\./,
      email.encoded
    )
  end

  test 'update preceptor email' do
    preceptor = preceptors(:one)
    user = users(:valid)
    email = UserMailer.update_preceptor(preceptor, user).deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [preceptor.email], email.to
    assert_equal 'Please Update Your Information', email.subject
    assert_match(
      /#{user.name} has requested that you update your preceptor profile\./,
      email.encoded
    )
  end

  test 'update annual email' do
    annual = annuals(:one)
    subject = ''
    body = 'This is in the body.'
    email = UserMailer.update_annual(annual, subject, body).deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [annual.applicant.email], email.to
    assert_equal "Please Update Your #{annual.year} Annual Information", email.subject
    assert_match(
      %r{/annuals/#{annual.id}/edit_me\?auth_token=#{annual.applicant.id_and_auth_token}},
      email.encoded
    )
  end

  test 'exit interview email' do
    applicant = applicants(:one)
    user = users(:valid)
    email = UserMailer.exit_interview(applicant, user).deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [applicant.email], email.to
    assert_equal 'Please Complete Your Exit Interview', email.subject
    assert_match(
      /#{user.name} has requested that you complete your exit interview\./,
      email.encoded
    )
  end

  test 'notify preceptor email' do
    applicant = applicants(:one)
    email = UserMailer.notify_preceptor(applicant).deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['preceptor_one@example.com'], email.to
    assert_equal "ACTION REQUIRED: You have been named as a potential preceptor for #{applicant.name}.", email.subject
    assert_match(
      /#{applicant.name} has recently submitted an application to the Training \
Program in Sleep, Circadian, and Respiratory Neurobiology\. This candidate name\
d you as a potential preceptor\./,
      email.encoded
    )
  end
end
