class ApplicationController < ActionController::Base
  protect_from_forgery

  layout "contour/layouts/application"

  protected

  def check_system_admin
    redirect_to root_path, alert: "You do not have sufficient privileges to access that page." unless current_user.system_admin?
  end

  def check_administrator
    redirect_to root_path, alert: "You do not have sufficient privileges to access that page." unless current_user.administrator?
  end
end
