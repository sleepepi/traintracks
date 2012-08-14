class Applicant < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :encryptable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  attr_accessible :accepted, :address1, :address2, :advisor, :cv_number, :applicant_type, :city, :concentration_major, :country, :coursework_completed, :current_institution,
                  :current_title, :cv, :degree_sought, :degree_type, :degrees_earned, :department_program, :disabled, :disadvantaged, :enrolled, :expected_year, :first_name, :last_name,
                  :middle_initial, :notes, :offered, :phone, :preferred_preceptor_id, :presentations, :previous_institutions, :primary_preceptor_id, :pubs_not_prev_rep, :research_description,
                  :research_project_title, :residency, :review_date, :reviewed, :secondary_preceptor_id, :source_of_support, :state, :status, :supported_by_tg, :training_grant_years, :tge, :thesis,
                  :trainee_code, :training_period_end_date, :training_period_start_date, :urm, :year, :year_department_program, :zip_code, :desired_start_date, :marital_status, :assurance, :reference_number,
                  :personal_statement, :publish, :curriculum_vitae, :curriculum_vitae_uploaded_at, :curriculum_vitae_cache, :disabled_description, :preferred_preceptor_two_id, :preferred_preceptor_three_id,
                  :previous_nsra_support, :alien_registration_number, :citizenship_status, :degree_types, :letters_from_a, :letters_from_b, :letters_from_c, :gender, :urm_types

  attr_accessor :publish

  mount_uploader :curriculum_vitae, DocumentUploader

  STATUS = ["current", "former"].collect{|i| [i,i]}
  APPLICANT_TYPE = ["predoc", "postdoc", "summer"].collect{|i| [i,i]}
  MARITAL_STATUS = ["single", "married", "divorced", "widowed"].collect{|i| [i,i]}
  CITIZENSHIP_STATUS = ["citizen", "permanent resident", "noncitizen"]
  DEGREE_TYPES = [['BA/BS', 'babs'], ['MA/MS', 'mams'], ['MD/DO', 'mddo'], ['PhD/ScD', 'phdscd'], ['Other Professional', 'other']]

  DEGREE_SOUGHT = ["MD/MBBS", "PhD", "MD/PhD", "Masters", "Undergrad", "Other"].collect{|i| [i,i]}

  GENDER = ["Male", "Female", "No Response"].collect{|i| [i,i]}
  URM_TYPES = [["Hispanic or Latin", 'hispanic latin'], ["American Indian or Alaska Native", 'americanindian alskanative'], ["Black or African American", 'black africanamerica'], ["Native Hawaiian or Pacific Islander", 'nativehawaiian pacific_islander']]

  serialize :degree_types, Array
  serialize :urm_types, Array

  # Callbacks
  before_save :set_submitted_at
  after_save :set_reference_number

  # Named Scopes
  scope :current, conditions: { deleted: false }
  scope :search, lambda { |*args| { conditions: [ 'LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ? or LOWER(email) LIKE ?', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%' ] } }

  # Model Validation
  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :reference_number, allow_blank: true, allow_nil: true
  validates_uniqueness_of :email, allow_blank: true, scope: :deleted

  validates_presence_of :expected_year, :degree_sought, unless: [:postdoc?, :not_submitted?]
  validates_presence_of :desired_start_date, :personal_statement, :curriculum_vitae, :current_institution, :degrees_earned, :current_title, :preferred_preceptor_id, :previous_institutions, :marital_status, :phone, :address1, :city, :state, :country, :zip_code, :advisor, :concentration_major, :department_program, if: :submitted?
  validates_presence_of :disabled_description, if: [:submitted?, :disabled?]
  validates_presence_of :alien_registration_number, if: [:submitted?, :permanent_resident?]
  validates_format_of :alien_registration_number, with: /\AA\d*\Z/, if: [:submitted?, :permanent_resident?]
  validates_presence_of :letters_from_a, :letters_from_b, :letters_from_c, if: [:submitted?]
  validates_presence_of :gender, if: [:submitted?]

  # Model Relationships
  belongs_to :preferred_preceptor, class_name: 'Preceptor', foreign_key: 'preferred_preceptor_id'
  belongs_to :preferred_preceptor_two, class_name: 'Preceptor', foreign_key: 'preferred_preceptor_two_id'
  belongs_to :preferred_preceptor_three, class_name: 'Preceptor', foreign_key: 'preferred_preceptor_three_id'
  belongs_to :primary_preceptor, class_name: 'Preceptor', foreign_key: 'primary_preceptor_id'
  belongs_to :secondary_preceptor, class_name: 'Preceptor', foreign_key: 'secondary_preceptor_id'

  # Applicant Methods

  def postdoc?
    self.applicant_type == 'postdoc'
  end

  def degree_types_names
    DEGREE_TYPES.select{|a,b| self.degree_types.include?(b)}.collect{|a,b| a}
  end

  def urm_types_names
    URM_TYPES.select{|a,b| self.urm_types.include?(b)}.collect{|a,b| a}
  end

  # def predoc_or_summer?
  #   ['predoc', 'summer'].include?(self.applicant_type)
  # end

  def trainee?
    self.enrolled?
  end

  def submitted?
    self.publish == '1'
  end

  def not_submitted?
    not self.submitted?
  end

  def permanent_resident?
    self.citizenship_status == 'permanent resident'
  end

  # Overriding Devise built-in active_for_authentication? method
  def active_for_authentication?
    super and not self.deleted?
  end

  def after_token_authentication
    self.reset_authentication_token!
    super
  end

  def name
    "#{first_name} #{middle_initial} #{last_name}"
  end

  def reverse_name
    "#{last_name}, #{first_name}"
  end

  def destroy
    update_column :deleted, true
  end

  def set_submitted_at
    if self.respond_to?('submitted_at') and self.submitted_at.blank? and self.publish.to_s == '1'
      self.submitted_at = Time.now
      self.originally_submitted_at = self.submitted_at if self.respond_to?('originally_submitted_at') and self.originally_submitted_at.blank?
    end
  end

  def set_reference_number(new_reference_number = Digest::SHA1.hexdigest(Time.now.usec.to_s))
    begin
      self.update_attributes reference_number: new_reference_number if self.respond_to?('reference_number') and self.reference_number.blank? and Applicant.where(reference_number: new_reference_number).count == 0
    rescue ActiveRecord::RecordNotUnique
      # Do nothing
    end
  end

  # Return true if an email has been sent to the applicant and they have not yet logged in
  def recently_notified?
    not self.emailed_at.blank? and not self.current_sign_in_at.blank? and self.current_sign_in_at < self.emailed_at
  end

  def update_general_information_email!(current_user)
    self.reset_authentication_token!
    self.update_column :emailed_at, Time.now
    UserMailer.update_application(self, current_user).deliver if Rails.env.production?
  end

end
