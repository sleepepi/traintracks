class ApplicationController < ActionController::Base
  protect_from_forgery

  layout "contour/layouts/application"

  def parse_date(date_string)
    date_string.to_s.split('/').last.size == 2 ? Date.strptime(date_string, "%m/%d/%y") : Date.strptime(date_string, "%m/%d/%Y") rescue ""
  end

  protected

  def check_system_admin
    redirect_to root_path, alert: "You do not have sufficient privileges to access that page." unless current_user.system_admin?
  end

  def check_administrator
    redirect_to root_path, alert: "You do not have sufficient privileges to access that page." unless current_user.administrator?
  end

  def reroute_applicant_and_preceptor
    redirect_to dashboard_applicants_path if applicant_signed_in?
    redirect_to dashboard_preceptors_path if preceptor_signed_in?
  end
end
