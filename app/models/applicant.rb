class Applicant < ActiveRecord::Base
  attr_accessible :accepted, :address1, :address2, :advisor, :applicant_number, :applicant_type, :appointment_type, :city, :concentration_major, :country, :coursework_comp, :current_institution, :current_position_or_source_of_support, :cv, :degree_sought, :degree_type, :degrees, :department_program, :disabled, :disadvantaged, :email, :enrolled, :expected_year, :fax, :first_name, :grant_years, :last_name, :middle_initial, :notes, :offered, :phone, :preferred_preceptor_id, :presentations, :previous_institutions, :primary_preceptor_id, :pubs_not_prev_rep, :research_description, :research_project_title, :residency, :review_date, :reviewed, :secondary_preceptor_id, :source_of_support, :state, :status, :summer, :supported_by_tg, :tg_years, :tge, :thesis, :trainee_code, :training_period_end_date, :training_period_start_date, :urm, :year, :year_department_program, :zip_code

  STATUS = ["current", "former"].collect{|i| [i,i]}
  APPLICANT_TYPE = ["predoc", "postdoc", "trainee"].collect{|i| [i,i]}

  # Named Scopes
  scope :current, conditions: { deleted: false }
  scope :search, lambda { |*args| { conditions: [ 'LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ? or LOWER(email) LIKE ?', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%' ] } }

  # Model Validation
  validates_presence_of :first_name, :last_name

  # Model Relationships
  belongs_to :preferred_preceptor, class_name: 'Preceptor', foreign_key: 'preferred_preceptor_id'
  belongs_to :primary_preceptor, class_name: 'Preceptor', foreign_key: 'primary_preceptor_id'
  belongs_to :secondary_preceptor, class_name: 'Preceptor', foreign_key: 'secondary_preceptor_id'

  # Applicant Methods

  def name
    "#{first_name} #{last_name}"
  end

  def reverse_name
    "#{last_name}, #{first_name}"
  end

  def destroy
    update_attribute :deleted, true
  end

end
