class PreceptorsController < ApplicationController
  before_filter :authenticate_user!, except: [:dashboard, :edit_me, :update_me]
  before_filter :check_administrator, except: [:dashboard, :edit_me, :update_me]

  before_filter :authenticate_preceptor!, only: [:dashboard, :edit_me, :update_me]

  def dashboard

  end

  def edit_me

  end

  def update_me
    respond_to do |format|
      if current_preceptor.update_attributes(post_params)
        format.html { redirect_to dashboard_preceptors_path, notice: 'Preceptor information successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit_me" }
        format.json { render json: current_preceptor.errors, status: :unprocessable_entity }
      end
    end
  end

  # Sends email to preceptor containg authentication token
  def email
    @preceptor = Preceptor.find(params[:id])
    @preceptor.update_general_information_email!(current_user)
    redirect_to @preceptor, notice: 'Preceptor has been notified by email to update application information.'
  end

  def index
    # current_user.update_column :preceptors_per_page, params[:preceptors_per_page].to_i if params[:preceptors_per_page].to_i >= 10 and params[:preceptors_per_page].to_i <= 200
    preceptor_scope = Preceptor.current # current_user.all_viewable_preceptors
    @search_terms = params[:search].to_s.gsub(/[^0-9a-zA-Z]/, ' ').split(' ')
    @search_terms.each{|search_term| preceptor_scope = preceptor_scope.search(search_term) }

    @order = scrub_order(Preceptor, params[:order], 'preceptors.last_name')
    preceptor_scope = preceptor_scope.order(@order)

    @preceptor_count = preceptor_scope.count
    @preceptors = preceptor_scope.page(params[:page]).per( 40 ) #current_user.preceptors_per_page)
  end

  # GET /preceptors/1
  # GET /preceptors/1.json
  def show
    @preceptor = Preceptor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @preceptor }
    end
  end

  # GET /preceptors/new
  # GET /preceptors/new.json
  def new
    @preceptor = Preceptor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @preceptor }
    end
  end

  # GET /preceptors/1/edit
  def edit
    @preceptor = Preceptor.find(params[:id])
  end

  # POST /preceptors
  # POST /preceptors.json
  def create
    @preceptor = Preceptor.new(post_params)

    @preceptor.skip_confirmation!

    respond_to do |format|
      if @preceptor.save
        format.html { redirect_to @preceptor, notice: 'Preceptor was successfully created.' }
        format.json { render json: @preceptor, status: :created, location: @preceptor }
      else
        format.html { render action: "new" }
        format.json { render json: @preceptor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /preceptors/1
  # PUT /preceptors/1.json
  def update
    @preceptor = Preceptor.find_by_id(params[:id])

    @preceptor.skip_reconfirmation! if @preceptor

    respond_to do |format|
      if @preceptor
        if @preceptor.update_attributes(post_params)
          format.html { redirect_to @preceptor, notice: 'Preceptor was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @preceptor.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to preceptors_path }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /preceptors/1
  # DELETE /preceptors/1.json
  def destroy
    @preceptor = Preceptor.find_by_id(params[:id])
    @preceptor.destroy if @preceptor

    respond_to do |format|
      format.html { redirect_to preceptors_path }
      format.json { head :no_content }
    end
  end

  private

  def post_params
    params[:preceptor] ||= {}
    [].each do |date|
      params[:preceptor][date] = parse_date(params[:preceptor][date])
    end

    if current_user and current_user.administrator?
      params[:preceptor]
    else
      params[:preceptor].slice(
        :email, :password, :password_confirmation, :remember_me, :degree, :first_name, :hospital_affiliation, :hospital_appointment, :last_name, :other_support, :program_role, :rank, :research_interest
       )
    end
  end

end
