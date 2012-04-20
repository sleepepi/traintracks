class SitesController < ApplicationController
  before_filter :reroute_applicant_and_preceptor, only: [ :dashboard ]
  before_filter :authenticate_user!, except: [ :about ]

  def about

  end

  def dashboard

  end
end
