class HospitalsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_administrator
  before_action :set_hospital, only: [ :show, :edit, :update, :destroy ]
  before_action :redirect_without_hospital, only: [ :show, :edit, :update, :destroy ]

  # GET /hospitals
  # GET /hospitals.json
  def index
    @order = scrub_order(Hospital, params[:order], "hospitals.name")
    @hospitals = Hospital.current.search(params[:search]).order(@order).page(params[:page]).per( 40 )
  end

  # GET /hospitals/1
  # GET /hospitals/1.json
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
  # POST /hospitals.json
  def create
    @hospital = Hospital.new(hospital_params)

    respond_to do |format|
      if @hospital.save
        format.html { redirect_to @hospital, notice: 'Hospital was successfully created.' }
        format.json { render action: 'show', status: :created, location: @hospital }
      else
        format.html { render action: 'new' }
        format.json { render json: @hospital.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hospitals/1
  # PUT /hospitals/1.json
  def update
    respond_to do |format|
      if @hospital.update(hospital_params)
        format.html { redirect_to @hospital, notice: 'Hospital was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @hospital.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hospitals/1
  # DELETE /hospitals/1.json
  def destroy
    @hospital.destroy

    respond_to do |format|
      format.html { redirect_to hospitals_path }
      format.json { head :no_content }
    end
  end

  private

    def set_hospital
      @hospital = Hospital.current.find_by_id(params[:id])
    end

    def redirect_without_hospital
      empty_response_or_root_path(hospitals_path) unless @hospital
    end

    def hospital_params
      params.require(:hospital).permit(:name)
    end

end
