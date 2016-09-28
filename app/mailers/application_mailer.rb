# frozen_string_literal: true

# Generic mailer class defines layout and from email address.
class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV['website_name']} <#{ActionMailer::Base.smtp_settings[:email]}>"
  add_template_helper(EmailHelper)
  layout 'mailer'

  protected

  def setup_email
    # attachments.inline['slice-logo.png'] = File.read('app/assets/images/try-slice-logo-no-text.png') rescue nil
  end

  def tg_admin_email
    if defined?(ENV['tg_admin_email']) && ENV['tg_admin_email'].present?
      ENV['tg_admin_email']
    else
      ActionMailer::Base.smtp_settings[:email]
    end
  end
end
