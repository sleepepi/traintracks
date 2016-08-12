# frozen_string_literal: true

# Allows preceptors to update their profile.
class PreceptorsController < ApplicationController
  before_action :authenticate_preceptor_from_token!,  only: [:dashboard, :edit_me, :update_me]
  before_action :authenticate_user!,                except: [:dashboard, :edit_me, :update_me]
  before_action :check_administrator,               except: [:dashboard, :edit_me, :update_me]
  before_action :authenticate_preceptor!,             only: [:dashboard, :edit_me, :update_me]
  before_action :set_preceptor,                       only: [:show, :edit, :update, :destroy, :email]
  before_action :redirect_without_preceptor,          only: [:show, :edit, :update, :destroy, :email]

  def dashboard
  end

  def edit_me
  end

  def update_me
    if current_preceptor.update(preceptor_params)
      redirect_to dashboard_preceptors_path, notice: 'Preceptor information successfully updated.'
    else
      render :edit_me
    end
  end

  # Sends email to preceptor containg authentication token
  def email
    @preceptor.update_general_information_email!(current_user)
    redirect_to @preceptor, notice: 'Preceptor has been notified by email to update application information.'
  end

  def index
    @order = scrub_order(Preceptor, params[:order], 'preceptors.last_name')
    preceptor_scope = Preceptor.current.search(params[:search]).order(@order)

    if params[:format] == 'csv'
      if preceptor_scope.count == 0
        redirect_to preceptors_path, alert: 'No data was exported since no preceptors matched the specified filters.'
        return
      end
      generate_csv(preceptor_scope)
      return
    end

    @preceptors = preceptor_scope.page(params[:page]).per(40)
  end

  # GET /preceptors/1
  def show
  end

  # GET /preceptors/new
  def new
    @preceptor = Preceptor.new
  end

  # GET /preceptors/1/edit
  def edit
  end

  # POST /preceptors
  def create
    @preceptor = Preceptor.new(preceptor_params)
    @preceptor.skip_confirmation!
    if @preceptor.save
      redirect_to @preceptor, notice: 'Preceptor was successfully created.'
    else
      render :new
    end
  end

  # PATCH /preceptors/1
  def update
    @preceptor.skip_reconfirmation!
    if @preceptor.update(preceptor_params)
      redirect_to @preceptor, notice: 'Preceptor was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /preceptors/1
  def destroy
    @preceptor.destroy
    redirect_to preceptors_path
  end

  private

  def set_preceptor
    @preceptor = Preceptor.find_by_id(params[:id])
  end

  def redirect_without_preceptor
    empty_response_or_root_path(preceptors_path) unless @preceptor
  end

  def preceptor_params
    if current_user && current_user.administrator?
      params.require(:preceptor).permit!
    else
      params.require(:preceptor).permit(
        :email, :password, :password_confirmation, :remember_me, :degree,
        :first_name, :hospital_affiliation, :hospital_appointment, :last_name,
        :other_support, :other_support_cache,
        :program_role, :research_interest,
        :biosketch, :biosketch_cache,
        :curriculum_vitae, :curriculum_vitae_cache,
        :publications, :grants
      )
    end
  end

  def generate_csv(preceptor_scope)
    @csv_string = CSV.generate do |csv|
      csv << [
        'Preceptor ID',
        # Preceptor Information
        'Email', 'Last Name', 'First Name',
        'Status', 'Degree',
        'Hospital Affiliation', 'Hospital Appointment', 'Rank',
        'Research Interest', 'Program Role',
        'Publications', 'Grants'
     ]

      preceptor_scope.each do |p|
        row = [
          p.id,
          # Preceptor Information
          p.email, p.last_name, p.first_name,
          p.status, p.degree,
          p.hospital_affiliation, p.hospital_appointment, p.rank,
          p.research_interest, p.program_role,
          p.publications, p.grants
        ]
        csv << row
      end
    end

    send_data @csv_string, type: 'text/csv; charset=iso-8859-1; header=present',
                           disposition: "attachment; filename=\"Training Grant Preceptors #{Time.zone.now.strftime("%Y.%m.%d %Ih%M %p")}.csv\""
  end
end
