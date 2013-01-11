class MailPreview < MailView
  def status_activated
    user = User.current.first
    UserMailer.status_activated(user)
  end

  def seminars_reminder
    applicant = Applicant.current_trainee.first
    seminars = Seminar.current
    UserMailer.seminars_reminder(applicant, seminars)
  end
end
