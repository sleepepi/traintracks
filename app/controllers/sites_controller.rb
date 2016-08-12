# frozen_string_literal: true

# General site controller for static pages.
class SitesController < ApplicationController
  before_action :reroute_applicant_and_preceptor, only: [:dashboard]
  before_action :authenticate_user!, except: [:about, :contact, :forgot_my_password, :version]

  def about
  end

  def dashboard
    flash.delete(:notice)
    applicant_scope = Applicant.current
    @submitted_after = parse_date(params[:submitted_after])
    @submitted_before = parse_date(params[:submitted_before])

    applicant_scope = applicant_scope.submitted_after(@submitted_after) unless @submitted_after.blank?
    applicant_scope = applicant_scope.submitted_before(@submitted_before) unless @submitted_before.blank?
    @applicants = applicant_scope
  end
end
