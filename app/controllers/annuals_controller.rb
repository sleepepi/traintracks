class AnnualsController < ApplicationController
  before_filter :authenticate_user!, except: [:edit_me, :update_me]
  before_filter :check_administrator, except: [:edit_me, :update_me]

  before_filter :authenticate_applicant!, only: [:edit_me, :update_me]

  # GET /annuals
  # GET /annuals.json
  def index
    annual_scope = current_user.all_viewable_annuals
    @order = scrub_order(Annual, params[:order], "annuals.id")
    annual_scope = annual_scope.order(@order)
    @annual_count = annual_scope.count
    @annuals = annual_scope.page(params[:page]).per( 20 )

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @annuals }
    end
  end

  # GET /annuals/1
  # GET /annuals/1.json
  def show
    @annual = current_user.all_viewable_annuals.find_by_id(params[:id])

    respond_to do |format|
      if @annual
        format.html # show.html.erb
        format.json { render json: @annual }
      else
        format.html { redirect_to annuals_path }
        format.json { head :no_content }
      end
    end
  end

  # GET /annuals/new
  # GET /annuals/new.json
  def new
    @annual = current_user.annuals.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @annual }
    end
  end

  # GET /annuals/1/edit
  def edit
    @annual = current_user.all_annuals.find_by_id(params[:id])
    redirect_to annuals_path unless @annual
  end

  def edit_me
    @annual = current_applicant.annuals.find_by_id(params[:id])
    redirect_to dashboard_applicants_path unless @annual
  end

  # POST /annuals
  # POST /annuals.json
  def create
    @annual = current_user.annuals.new(post_params)

    respond_to do |format|
      if @annual.save
        format.html { redirect_to @annual, notice: 'Annual was successfully created.' }
        format.json { render json: @annual, status: :created, location: @annual }
      else
        format.html { render action: "new" }
        format.json { render json: @annual.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /annuals/1
  # PUT /annuals/1.json
  def update
    @annual = current_user.all_annuals.find_by_id(params[:id])

    respond_to do |format|
      if @annual
        if @annual.update_attributes(post_params)
          format.html { redirect_to @annual, notice: 'Annual was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @annual.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to annuals_path }
        format.json { head :no_content }
      end
    end
  end

  def update_me
    @annual = current_applicant.annuals.find_by_id(params[:id])

    respond_to do |format|
      if @annual
        if @annual.update_attributes(post_params)
          format.html { redirect_to dashboard_applicants_path, notice: 'Annual information was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit_me" }
          format.json { render json: @annual.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to dashboard_applicants_path }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /annuals/1
  # DELETE /annuals/1.json
  def destroy
    @annual = current_user.all_annuals.find_by_id(params[:id])
    @annual.destroy if @annual

    respond_to do |format|
      format.html { redirect_to annuals_path }
      format.json { head :no_content }
    end
  end

  private

  def post_params
    params[:annual] ||= {}

    params[:annual][:applicant_id] = current_applicant.id if current_applicant

    params[:annual].slice(
       :applicant_id, :year, :coursework_completed, :publications, :presentations, :research_description, :source_of_support, :nih_other_support, :nih_other_support_cache, :nih_other_support_uploaded_at
    )
  end

end
