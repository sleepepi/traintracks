# frozen_string_literal: true

# The applicant class provides methods to to access information about trainees
# and applicants.
class Applicant < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :encryptable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable, :confirmable,
         :recoverable, :rememberable, :trackable, :lockable, :validatable

  # Concerns
  include TokenAuthenticatable, Deletable

  # # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  # # Applicant Information
  # attr_accessible :first_name, :last_name, :middle_initial, :applicant_type, :tge, :desired_start_date,
  #                 :personal_statement, :alien_registration_number, :citizenship_status

  # # Uploaded Curriculum Vitae
  # attr_accessible :curriculum_vitae, :curriculum_vitae_uploaded_at, :curriculum_vitae_cache

  # # Education
  # attr_accessible :current_institution, :department_program, :current_position, :degrees_earned,
  #                 :degree_sought, :expected_year, :residency, :research_interests, :research_interests_other,
  #                 :preferred_preceptor_id, :preferred_preceptor_two_id, :preferred_preceptor_three_id,
  #                 :previous_nrsa_support

  # # Demographic Information
  # attr_accessible :gender, :disabled, :disabled_description, :disadvantaged, :urm, :urm_types, :marital_status

  # # Contact Information
  # attr_accessible :phone, :address1, :address2, :city, :state, :country, :zip_code

  # # Applicant Assurance
  # attr_accessible :publish, :publish_annual, :assurance, :letters_from_a, :letters_from_b, :letters_from_c

  # # Administrator Only
  # attr_accessible :reviewed, :review_date, :offered, :accepted, :enrolled, :cv_number, :degree_type, :trainee_code,
  #                 :status, :training_grant_years, :supported_by_tg, :training_period_start_date,
  #                 :training_period_end_date, :notes, :primary_preceptor_id, :secondary_preceptor_id,
  #                 :admin_update

  # # Termination Questions for Enrolled Applicants
  # attr_accessible :publish_termination, :future_email, :entrance_year, :t32_funded, :t32_funded_years,
  #                 :academic_program_completed, :research_project_title, :laboratories, :immediate_transition,
  #                 :transition_position, :transition_position_other, :termination_feedback,
  #                 :certificate_application, :certificate_application_cache

  attr_accessor :publish, :publish_annual, :publish_termination, :admin_update

  mount_uploader :curriculum_vitae, DocumentUploader
  mount_uploader :certificate_application, DocumentUploader
  mount_uploader :approved_irb_document, DocumentUploader
  mount_uploader :approved_iacuc_document, DocumentUploader

  STATUS = ["current", "former"].collect{|i| [i,i]}
  APPLICANT_TYPE = ["predoc", "postdoc", "summer"].collect{|i| [i,i]}
  MARITAL_STATUS = [["Single", "single"], ["Married", "married"], ["Divorced", "divorced"], ["Widowed", "widowed"]]
  CITIZENSHIP_STATUS = ["citizen", "permanent resident", "noncitizen", "unknown"]
  DEGREE_TYPES = [['BA/BS', 'babs'], ['MA/MS', 'mams'], ['MD/DO', 'mddo'], ['PhD/ScD', 'phdscd'], ['Other Professional', 'other']]
  LABORATORIES = [['Basic Science', 'basic science'], ['Clinical Science', 'clinical science'], ['Population-based Science', 'population-based science'], ['Translational', 'translational'], ['Other', 'other']]
  TRANSITION_POSITIONS = [['Research Fellow', 'research fellow'], ['Clinical Fellow', 'clinical fellow'], ['Instructor/Assistant Professor', 'instructor or assistant professor'], ['Commercial Research Laboratory', 'commercial research laboratory'], ['Private Practice', 'private practice'], ['Other', 'other']]

  DEGREE_SOUGHT = ["MD/MBBS", "PhD", "MD/PhD", "Masters", "Undergrad", "Other"].collect{|i| [i,i]}

  RESEARCH_INTERESTS = [['Human Physiology', 'human physiology'], ['Circadian/Chronobiology', 'circadian chronobiology'], ['Neurophysiology', 'neurophysiology'], ['Molecular Biology', 'molecular biology'],
                        ['Mathematical Modeling', 'mathematical modeling'], ['Physiology', 'physiology'], ['Neuroanatomy', 'neuroanatomy'], ['Neuropsychiatry', 'neuropsychiatry'], ['Neuropsychology', 'neuropsychology'],
                        ['Learning and Memory', 'learning and memory'], ['Neuropharmacology', 'neuropharmacology'], ['Cardiorespiratory Physiology', 'cardiorespiratory physiology'], ['Upper Airway Muscle Physiology', 'upper airway muscle physiology'],
                        ['Sleep', 'sleep'], ['Genetics of Circadian Clocks', 'genetics of circadian clocks'], ['Other (please specify)', 'other']]


  GENDER = ["Male", "Female", "No Response"].collect{|i| [i,i]}
  URM_TYPES = [["Hispanic or Latin", 'hispanic latin'], ["American Indian or Alaska Native", 'americanindian alskanative'], ["Black or African American", 'black africanamerica'], ["Native Hawaiian or Pacific Islander", 'nativehawaiian pacific_islander']]

  serialize :urm_types, Array
  serialize :laboratories, Array
  serialize :transition_position, Array
  serialize :research_interests, Array
  serialize :degrees_earned, Array

  # Callbacks
  before_validation :set_alien_registration_number, :set_password
  before_save :set_submitted_at, :set_tge, :ensure_authentication_token
  before_validation :check_degrees_earned, if: :annual_or_publish?
  after_save :notify_preceptor

  # Named Scopes
  scope :search, lambda { |arg| where( 'LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ? or LOWER(email) LIKE ?', arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%') ) }
  scope :submitted_before, lambda { |arg| where( "applicants.originally_submitted_at < ?", (arg+1.day).at_midnight ) }
  scope :submitted_after, lambda { |arg| where( "applicants.originally_submitted_at >= ?", arg.at_midnight ) }
  scope :current_trainee, -> { current.where( enrolled: true, status: 'current' ) }
  scope :supported_by_tg_in_last_fifteen_years, -> { current.where( enrolled: true, supported_by_tg: true ).where( 'training_period_end_date >= ?', Date.today - 15.years ) }

  # Model Validation
  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :email, allow_blank: true, scope: :deleted

  validates_presence_of :expected_year, :degree_sought, unless: [:postdoc?, :not_submitted?]
  validates_presence_of :desired_start_date, :personal_statement, :research_interests, :preferred_preceptor_id, :marital_status, if: :submitted?
  validates_presence_of :research_interests_other, if: [:submitted?, 'research_interests.include?("other")']
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

  # Validations required for Exit Interview
  validates_presence_of :future_email, :entrance_year, if: :termination?
  validates_presence_of :t32_funded, if: [:termination?, 't32_funded.nil?']
  validates_presence_of :t32_funded_years, if: [:termination?, :t32_funded?]
  validates_presence_of :academic_program_completed, if: [:termination?, 'academic_program_completed.nil?']
  validates_presence_of :certificate_application, if: [:termination?, :academic_program_completed?]
  validates_presence_of :research_project_title, :laboratories, if: :termination?
  validates_presence_of :immediate_transition, if: [:termination?, 'immediate_transition.nil?']
  validates_presence_of :transition_position, if: [:termination?, :immediate_transition?]
  validates_presence_of :transition_position_other, if: [:termination?, :other_position_selected?]

  # Max Length Validation for PostgreSQL strings
  validates_length_of :first_name, :last_name, :middle_initial, :current_institution, :department_program, :degree_type, :residency, :current_position, :address1, :address2, :city, :state, :country, :zip_code, :phone, :training_grant_years, :research_project_title, :trainee_code, :letters_from_a, :letters_from_b, :letters_from_c, :future_email, :transition_position_other, :research_interests_other, :research_in_progress_title, :curriculum_advisor, maximum: 255

  # Model Relationships
  belongs_to :preferred_preceptor, class_name: 'Preceptor', foreign_key: 'preferred_preceptor_id'
  belongs_to :preferred_preceptor_two, class_name: 'Preceptor', foreign_key: 'preferred_preceptor_two_id'
  belongs_to :preferred_preceptor_three, class_name: 'Preceptor', foreign_key: 'preferred_preceptor_three_id'
  belongs_to :primary_preceptor, class_name: 'Preceptor', foreign_key: 'primary_preceptor_id'
  belongs_to :secondary_preceptor, class_name: 'Preceptor', foreign_key: 'secondary_preceptor_id'
  has_many :annuals, -> { where( deleted: false ).order('year DESC') }
  has_and_belongs_to_many :seminars

  # Applicant Methods

  def avatar_url(size = 80, default = 'mm')
    gravatar_id = Digest::MD5.hexdigest(self.email.to_s.downcase)
    "//gravatar.com/avatar/#{gravatar_id}.png?&s=#{size}&r=pg&d=#{default}"
  end

  def add_seminar(seminar)
    self.seminars << seminar unless self.seminars.include?(seminar)
  end

  def remove_seminar(seminar)
    self.seminars.delete(seminar)
  end

  def eligible_seminar?(seminar)
    Seminar.current.where(id: seminar.id).where("(DATE(presentation_date) >= ? or ? IS NULL) and (DATE(presentation_date) <= ? or ? IS NULL) and DATE(presentation_date) <= ?", self.training_period_start_date, self.training_period_start_date, self.training_period_end_date, self.training_period_end_date, Date.today).count > 0
  end

  def eligible_seminars(all_seminars)
    Seminar.where(id: all_seminars.collect(&:id)).where("(DATE(presentation_date) >= ? or ? IS NULL) and (DATE(presentation_date) <= ? or ? IS NULL) and DATE(presentation_date) <= ?", self.training_period_start_date, self.training_period_start_date, self.training_period_end_date, self.training_period_end_date, Date.today)
  end

  def seminars_attended(all_seminars)
    self.seminars.where(id: eligible_seminars(all_seminars).select(:id)).count
  end

  def seminars_attended_percentage(all_seminars)
    if eligible_seminars(all_seminars).count == 0
      0
    else
      seminars_attended(all_seminars) * 100 / eligible_seminars(all_seminars).count
    end
  end

  def degrees_earned_text
    self.degrees_earned.collect{|d| "#{Applicant.degree_type_name(d[:degree_type])} #{d[:institution]} #{d[:year]} #{d[:advisor]} #{d[:thesis]} #{d[:concentration_major]}"}.join("\n")
  end

  def other_position_selected?
    self.transition_position.include?('other')
  end

  def postdoc?
    self.applicant_type == 'postdoc'
  end

  def self.degree_type_name(degree_type)
    DEGREE_TYPES.select{|a,b| degree_type == b}.collect{|a,b| a}.first
  end

  def urm_types_names
    URM_TYPES.select{|a,b| self.urm_types.include?(b)}.collect{|a,b| a}
  end

  # def predoc_or_summer?
  #   ['predoc', 'summer'].include?(self.applicant_type)
  # end

  def trainee?
    enrolled?
  end

  def termination?
    publish_termination == '1'
  end

  # Validates on annual or on published
  def annual_or_publish?
    publish_annual == '1' || publish == '1'
  end

  # Should be changed to 'publish?' for consistency
  def submitted?
    publish == '1'
  end

  def not_submitted?
    !submitted?
  end

  def permanent_resident?
    citizenship_status == 'permanent resident'
  end

  # Overriding Devise built-in active_for_authentication? method
  def active_for_authentication?
    super && !deleted?
  end

  def devise_path
    'trainee/'
  end

  def name
    "#{first_name} #{middle_initial} #{last_name}"
  end

  def reverse_name
    "#{last_name}, #{first_name}"
  end

  def email_with_name
    "#{name} <#{email}>"
  end

  def years_since_training_end_date
    ((Date.today - self.training_period_end_date).day / 1.year).floor
  rescue
    0
  end

  def destroy
    super
    update_column :email, ''
    update_column :updated_at, Time.zone.now
  end

  def set_submitted_at
    if respond_to?('submitted_at') && submitted_at.blank? && publish.to_s == '1'
      self.submitted_at = Time.zone.now
      self.originally_submitted_at = submitted_at if respond_to?('originally_submitted_at') && originally_submitted_at.blank?
    end
    true
  end

  def set_tge
    if respond_to?('tge')
      self.tge = ['citizen', 'permanent resident'].include?(citizenship_status)
    end
    true
  end

  def notify_preceptor
    if publish.to_s == '1' && preferred_preceptor && preferred_preceptor.email.present?
      UserMailer.notify_preceptor(self).deliver_now if EMAILS_ENABLED
    end
  end

  def set_alien_registration_number
    if attribute_present?('alien_registration_number')
      self.alien_registration_number = 'A' + alien_registration_number.to_s.gsub(/[^\d]/, '')
    end
    true
  end

  def set_password
    if respond_to?('encrypted_password') && encrypted_password.blank?
      self.password = Devise.friendly_token
      self.password_confirmation = password
    end
    true
  end

  def check_degrees_earned
    result = true
    degrees_earned.each do |degree_earned|
      result = true
      [:degree_type, :institution].each do |attr|
        if degree_earned[attr].blank?
          self.errors.add(:degrees_earned, "#{attr.to_s.gsub('_', ' ')} can't be blank" ) unless errors[:degrees_earned].include?("#{attr.to_s.gsub('_', ' ')} can't be blank")
          result = false
        end
      end
      if degree_earned[:year].to_i <= 0
        self.errors.add(:degrees_earned, "year can't be blank" ) unless errors[:degrees_earned].include?("year can't be blank")
        result = false
      end
    end
    result
  end

  # Return true if an email has been sent to the applicant and they have not yet logged in
  def recently_notified?
    emailed_at.present? && current_sign_in_at.present? && current_sign_in_at < emailed_at
  end

  def update_general_information_email!(current_user)
    update_column :emailed_at, Time.zone.now
    UserMailer.update_application(self, current_user).deliver_now if EMAILS_ENABLED
  end

  def send_annual_reminder!(current_user, year, subject, body)
    annual = Annual.current.where(applicant_id: id, year: year).first_or_create(user_id: current_user.id)

    if annual
      if annual.submitted?
        # Do nothing
      elsif annual.applicant && annual.applicant.email.present?
        update_column :emailed_at, Time.zone.now
        UserMailer.update_annual(annual, subject, body).deliver_now if EMAILS_ENABLED
      end
    end
  end

  def send_termination!(current_user)
    update_column :emailed_at, Time.zone.now
    UserMailer.exit_interview(self, current_user).deliver_now if EMAILS_ENABLED
  end

  protected

  # Override Devise Email Required
  def email_required?
    admin_update != '1'
  end
end
