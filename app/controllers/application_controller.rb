class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery

  layout 'layouts/application-footer'

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up){ |u| u.permit( :first_name, :last_name, :email, :password, :password_confirmation ) }
  end

  def parse_date(date_string, default_date = '')
    date_string.to_s.split('/').last.size == 2 ? Date.strptime(date_string, '%m/%d/%y') : Date.strptime(date_string, '%m/%d/%Y') rescue default_date
  end

  def scrub_order(model, params_order, default_order)
    (params_column, params_direction) = params_order.to_s.strip.downcase.split(' ')
    direction = (params_direction == 'desc' ? 'DESC' : nil)
    column_name = (model.column_names.collect{|c| model.table_name + '.' + c}.select{|c| c == params_column}.first)
    order = column_name.blank? ? default_order : [column_name, direction].compact.join(' ')
    order
  end

  def check_system_admin
    redirect_to root_path, alert: 'You do not have sufficient privileges to access that page.' unless current_user.system_admin?
  end

  def check_administrator
    redirect_to root_path, alert: 'You do not have sufficient privileges to access that page.' unless current_user.administrator?
  end

  def reroute_applicant_and_preceptor
    redirect_to dashboard_applicants_path if applicant_signed_in?
    redirect_to dashboard_preceptors_path if preceptor_signed_in?
  end

  def empty_response_or_root_path(path = root_path)
    respond_to do |format|
      format.html { redirect_to path }
      format.js { head :ok }
      format.json { head :no_content }
    end
  end

  def authenticate_applicant_from_token!
    applicant_id = params[:auth_token].to_s.split('-').first
    auth_token = params[:auth_token].to_s.gsub(/^#{applicant_id}-/, '')
    applicant                  = applicant_id && Applicant.find_by_id(applicant_id)
    if applicant && Devise.secure_compare(applicant.authentication_token, auth_token)
      sign_in applicant
    end
  end

  def authenticate_preceptor_from_token!
    preceptor_id = params[:auth_token].to_s.split('-').first
    auth_token = params[:auth_token].to_s.gsub(/^#{preceptor_id}-/, '')
    preceptor               = preceptor_id && Preceptor.find_by_id(preceptor_id)
    if preceptor && Devise.secure_compare(preceptor.authentication_token, auth_token)
      sign_in preceptor
    end
  end
end
