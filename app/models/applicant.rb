class Applicant < ActiveRecord::Base
  attr_accessible :accepted, :address1, :address2, :advisor, :cv_number, :applicant_type, :appointment_type, :city, :concentration_major, :country, :coursework_completed, :current_institution,
                  :current_title, :cv, :degree_sought, :degree_type, :degrees, :department_program, :disabled, :disadvantaged, :email, :enrolled, :expected_year, :first_name, :last_name,
                  :middle_initial, :notes, :offered, :phone, :preferred_preceptor_id, :presentations, :previous_institutions, :primary_preceptor_id, :pubs_not_prev_rep, :research_description,
                  :research_project_title, :residency, :review_date, :reviewed, :secondary_preceptor_id, :source_of_support, :state, :status, :summer, :supported_by_tg, :training_grant_years, :tge, :thesis,
                  :trainee_code, :training_period_end_date, :training_period_start_date, :urm, :year, :year_department_program, :zip_code, :desired_start_date, :marital_status, :assurance, :reference_number

  STATUS = ["current", "former"].collect{|i| [i,i]}
  APPLICANT_TYPE = ["predoc", "postdoc"].collect{|i| [i,i]}
  MARITAL_STATUS = ["single", "married", "divorced", "widowed"].collect{|i| [i,i]}

  before_save :set_submitted_at
  after_save :set_reference_number

  # Named Scopes
  scope :current, conditions: { deleted: false }
  scope :search, lambda { |*args| { conditions: [ 'LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ? or LOWER(email) LIKE ?', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%' ] } }

  # Model Validation
  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :reference_number, allow_blank: true, allow_nil: true

  # Model Relationships
  belongs_to :preferred_preceptor, class_name: 'Preceptor', foreign_key: 'preferred_preceptor_id'
  belongs_to :primary_preceptor, class_name: 'Preceptor', foreign_key: 'primary_preceptor_id'
  belongs_to :secondary_preceptor, class_name: 'Preceptor', foreign_key: 'secondary_preceptor_id'

  # Applicant Methods

  def name
    "#{first_name} #{middle_initial} #{last_name}"
  end

  def reverse_name
    "#{last_name}, #{first_name}"
  end

  def destroy
    update_attribute :deleted, true
  end

  def set_submitted_at
    self.submitted_at = Time.now if self.respond_to?('reference_number') and self.assurance and self.submitted_at.blank?
  end

  def set_reference_number(new_reference_number = Digest::SHA1.hexdigest(Time.now.usec.to_s))
    begin
      self.update_attribute :reference_number, new_reference_number if self.respond_to?('reference_number') and self.reference_number.blank? and Applicant.where(reference_number: new_reference_number).count == 0
    rescue ActiveRecord::RecordNotUnique
      # Do nothing
    end
  end

end
