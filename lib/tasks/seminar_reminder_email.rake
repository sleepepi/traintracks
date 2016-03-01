# frozen_string_literal: true

desc 'Launched by crontab -e, send a seminar reminder email to current trainees.'
task seminar_reminder_email: :environment do
  # At 2am every day, in production mode
  upcoming_seminars = Seminar.current.date_before(Time.zone.today + 2.days).date_after(Time.zone.today + 2.days)

  if EMAILS_ENABLED && upcoming_seminars.size > 0
    Applicant.current_trainee.each do |applicant|
      UserMailer.seminars_reminder(applicant, upcoming_seminars).deliver_later if applicant.email.present?
    end
  end
end
