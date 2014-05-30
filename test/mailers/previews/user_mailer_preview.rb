class UserMailerPreview < ActionMailer::Preview

  def help_email
    applicant = Applicant.first
    subject = "This is the Subject"
    body = "This is the Body"
    UserMailer.help_email(applicant, subject, body)
  end

  def notify_system_admin
    system_admin = User.current.first
    user = User.current.first
    UserMailer.notify_system_admin(system_admin, user)
  end

  def status_activated
    user = User.current.first
    UserMailer.status_activated(user)
  end

  def update_application
    applicant = Applicant.first
    user = User.current.first
    UserMailer.update_application(applicant, user)
  end

  def update_preceptor
    preceptor = Preceptor.first
    user = User.current.first
    UserMailer.update_preceptor(preceptor, user)
  end

  def update_annual
    annual = Annual.first
    subject = "This is the Subject"
    body = "This is the Body"
    UserMailer.update_annual(annual, subject, body)
  end

  def exit_interview
    applicant = Applicant.current_trainee.first
    user = User.current.first
    UserMailer.exit_interview(applicant, user)
  end

  def seminars_reminder
    applicant = Applicant.current_trainee.first
    seminars = Seminar.current
    UserMailer.seminars_reminder(applicant, seminars)
  end

  def notify_preceptor
    applicant = Applicant.first
    UserMailer.notify_preceptor(applicant)
  end

end
