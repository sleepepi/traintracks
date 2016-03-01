# frozen_string_literal: true

# Allows hospital list to be maintained by administrator
class HospitalsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_administrator
  before_action :set_hospital, only: [:show, :edit, :update, :destroy]

  # GET /hospitals
  def index
    @order = scrub_order(Hospital, params[:order], 'hospitals.name')
    @hospitals = Hospital.current
                         .search(params[:search])
                         .order(@order)
                         .page(params[:page]).per(40)
  end

  # GET /hospitals/1
  def show
  end

  # GET /hospitals/new
  def new
    @hospital = Hospital.new
  end

  # GET /hospitals/1/edit
  def edit
  end

  # POST /hospitals
  def create
    @hospital = Hospital.new(hospital_params)

    if @hospital.save
      redirect_to @hospital, notice: 'Hospital was successfully created.'
    else
      render :new
    end
  end

  # PATCH /hospitals/1
  def update
    if @hospital.update(hospital_params)
      redirect_to @hospital, notice: 'Hospital was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /hospitals/1
  def destroy
    @hospital.destroy
    redirect_to hospitals_path
  end

  private

  def set_hospital
    @hospital = Hospital.current.find_by_id(params[:id])
    redirect_without_hospital
  end

  def redirect_without_hospital
    empty_response_or_root_path(hospitals_path) unless @hospital
  end

  def hospital_params
    params.require(:hospital).permit(:name)
  end
end
