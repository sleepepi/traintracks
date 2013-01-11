desc 'Launched by crontab -e, send a seminar reminder email to current trainees.'
task :seminar_reminder_email => :environment do
  # At 2am every day, in production mode
  upcoming_seminars = Seminar.current.date_before(Date.today + 2.days).date_after(Date.today + 2.days)

  if upcoming_seminars.size > 0
    Applicant.current_trainee.each do |applicant|
      UserMailer.seminars_reminder(applicant, upcoming_seminars).deliver if Rails.env.production? and not applicant.email.blank?
    end
  end
end
