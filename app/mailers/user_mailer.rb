class UserMailer < ActionMailer::Base
  default from: "#{DEFAULT_APP_NAME} <#{ActionMailer::Base.smtp_settings[:user_name]}>"
  add_template_helper(ApplicationHelper)

  def notify_system_admin(system_admin, user)
    setup_email
    @system_admin = system_admin
    @user = user
    mail(to: system_admin.email,
         subject: "#{user.name} Signed Up",
         reply_to: user.email)
  end

  def status_activated(user)
    setup_email
    @user = user
    mail(to: user.email,
         subject: "#{user.name}'s Account Activated")
  end

  def update_application(applicant, user)
    setup_email
    @applicant = applicant
    @user = user
    mail(to: applicant.email,
         subject: "Please Update Your Application Information",
         reply_to: user.email)
  end

  def update_preceptor(preceptor, user)
    setup_email
    @preceptor = preceptor
    @user = user
    mail(to: preceptor.email,
         subject: "Please Update Your Information",
         reply_to: user.email)
  end

  def update_annual(annual, subject, body)
    setup_email
    @annual = annual
    mail(to: annual.applicant.email,
         subject: subject.blank? ? "Please Update Your #{annual.year} Annual Information" : subject,
         body: "Dear #{annual.applicant.name},\n\n" + body + "\n\n#{SITE_URL}/annuals/#{annual.id}/edit_me?auth_token=#{annual.applicant.authentication_token}",
         reply_to: annual.user.email)
  end

  protected

  def setup_email
    @footer_html = "Change email settings here: <a href=\"#{SITE_URL}/settings\">#{SITE_URL}/settings</a>.<br /><br />".html_safe
    @footer_txt = "Change email settings here: #{SITE_URL}/settings."
  end
end
