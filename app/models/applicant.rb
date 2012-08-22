class Applicant < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :encryptable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # Applicant Information
  attr_accessible :first_name, :last_name, :middle_initial, :applicant_type, :tge, :desired_start_date,
                  :personal_statement, :alien_registration_number, :citizenship_status

  # Education
  attr_accessible :advisor, :concentration_major, :current_institution, :cv, :degree_sought,
                  :department_program, :expected_year, :preferred_preceptor_id, :preferred_preceptor_two_id,
                  :preferred_preceptor_three_id, :thesis, :degrees_earned, :current_position,
                  :previous_nsra_support, :degree_types

  # Demographic Information
  attr_accessible :gender, :disabled, :disabled_description, :disadvantaged, :urm, :urm_types, :marital_status

  # Contact Information
  attr_accessible :phone, :address1, :address2, :city, :state, :country, :zip_code

  # Postdoc Only
  attr_accessible :residency

  # Trainee Only
  attr_accessible :research_project_title

  # Applicant Assurance
  attr_accessible :publish, :publish_annual, :assurance, :letters_from_a, :letters_from_b, :letters_from_c

  # Uploaded Curriculum Vitae
  attr_accessible :curriculum_vitae, :curriculum_vitae_uploaded_at, :curriculum_vitae_cache

  # Administrator Only
  attr_accessible :reviewed, :review_date, :offered, :accepted, :enrolled, :cv_number, :degree_type, :trainee_code,
                  :status, :training_grant_years, :supported_by_tg, :training_period_start_date,
                  :training_period_end_date, :notes, :primary_preceptor_id, :secondary_preceptor_id

  attr_accessor :publish, :publish_annual

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
  before_validation :set_alien_registration_number
  before_save :set_submitted_at, :set_tge
  after_save :notify_preceptor

  # Named Scopes
  scope :current, conditions: { deleted: false }
  scope :search, lambda { |*args| { conditions: [ 'LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ? or LOWER(email) LIKE ?', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%' ] } }
  scope :submitted_before, lambda { |*args| { conditions: ["applicants.originally_submitted_at < ?", (args.first+1.day).at_midnight]} }
  scope :submitted_after, lambda { |*args| { conditions: ["applicants.originally_submitted_at >= ?", args.first.at_midnight]} }


  # Model Validation
  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :email, allow_blank: true, scope: :deleted

  validates_presence_of :expected_year, :degree_sought, unless: [:postdoc?, :not_submitted?]
  validates_presence_of :desired_start_date, :personal_statement, :preferred_preceptor_id, :marital_status, :advisor, :concentration_major,  if: :submitted?
  validates_presence_of :disabled_description, if: [:submitted?, :disabled?]
  validates_presence_of :alien_registration_number, if: [:submitted?, :permanent_resident?]
  validates_format_of :alien_registration_number, with: /\AA\d*\Z/, if: [:submitted?, :permanent_resident?]
  validates_presence_of :letters_from_a, :letters_from_b, :letters_from_c, if: [:submitted?]
  validates_presence_of :gender, if: [:submitted?]

  # Validations required on Annual or Publish State
  # Contact Information
  validates_presence_of :phone, :address1, :city, :state, :country, :zip_code, if: :annual_or_publish?
  # Education Experience
  validates_presence_of :curriculum_vitae, :current_institution, :department_program, :current_position, :degrees_earned, if: :annual_or_publish?


  # Model Relationships
  belongs_to :preferred_preceptor, class_name: 'Preceptor', foreign_key: 'preferred_preceptor_id'
  belongs_to :preferred_preceptor_two, class_name: 'Preceptor', foreign_key: 'preferred_preceptor_two_id'
  belongs_to :preferred_preceptor_three, class_name: 'Preceptor', foreign_key: 'preferred_preceptor_three_id'
  belongs_to :primary_preceptor, class_name: 'Preceptor', foreign_key: 'primary_preceptor_id'
  belongs_to :secondary_preceptor, class_name: 'Preceptor', foreign_key: 'secondary_preceptor_id'
  has_many :annuals, conditions: { deleted: false }, order: 'year DESC'

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

  # Validates on annual or on published
  def annual_or_publish?
    self.publish_annual == '1' or self.publish == '1'
  end

  # Should be changed to 'publish?' for consistency
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
    true
  end

  def set_tge
    if self.respond_to?('tge')
      self.tge = ["citizen", "permanent resident"].include?(self.citizenship_status)
    end
    true
  end

  def notify_preceptor
    if self.publish.to_s == '1' and self.preferred_preceptor and not self.preferred_preceptor.email.blank?
      UserMailer.notify_preceptor(self).deliver if Rails.env.production?
    end
  end

  def set_alien_registration_number
    if attribute_present?("alien_registration_number")
      self.alien_registration_number = "A" + alien_registration_number.to_s.gsub(/[^\d]/, '')
    end
    true
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

  def send_annual_reminder!(current_user, year, subject, body)
    annual = Annual.current.find_or_create_by_applicant_id_and_year(self.id, year, { user_id: current_user.id })

    if annual
      if annual.submitted?
        # Do nothing
      elsif annual.applicant and not annual.applicant.email.blank?
        self.reset_authentication_token!
        annual.reload
        self.update_column :emailed_at, Time.now
        UserMailer.update_annual(annual, subject, body).deliver if Rails.env.production?
      end
    end
  end

end
