# frozen_string_literal: true

# The applicant class provides methods to to access information about trainees
# and applicants.
class Applicant < ApplicationRecord
  attr_accessor :degree_hashes
  after_save :set_degrees

  # Include default devise modules. Others available are:
  # :encryptable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable, :confirmable,
         :recoverable, :rememberable, :trackable, :lockable, :validatable

  # Concerns
  include TokenAuthenticatable, Deletable, Forkable

  # # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  # # Applicant Information
  # attr_accessible :first_name, :last_name, :middle_initial, :applicant_type, :tge, :desired_start_date,
  #                 :personal_statement, :alien_registration_number, :citizenship_status

  # # Uploaded Curriculum Vitae
  # attr_accessible :curriculum_vitae, :curriculum_vitae_uploaded_at, :curriculum_vitae_cache

  # # Education
  # attr_accessible :current_institution, :department_program, :current_position, :degree_hashes,
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

  STATUS = %w(current former).collect { |i| [i, i] }
  APPLICANT_TYPE = %w(predoc postdoc summer).collect { |i| [i, i] }
  MARITAL_STATUS = [['Single', 'single'], ['Married', 'married'], ['Divorced', 'divorced'], ['Widowed', 'widowed']]
  CITIZENSHIP_STATUS = ['citizen', 'permanent resident', 'noncitizen', 'unknown']
  LABORATORIES = [['Basic Science', 'basic science'], ['Clinical Science', 'clinical science'], ['Population-based Science', 'population-based science'], ['Translational', 'translational'], ['Other', 'other']]
  TRANSITION_POSITIONS = [['Research Fellow', 'research fellow'], ['Clinical Fellow', 'clinical fellow'], ['Instructor/Assistant Professor', 'instructor or assistant professor'], ['Commercial Research Laboratory', 'commercial research laboratory'], ['Private Practice', 'private practice'], ['Other', 'other']]

  DEGREE_SOUGHT = ['MD/MBBS', 'PhD', 'MD/PhD', 'Masters', 'Undergrad', 'Other'].collect{|i| [i,i]}

  RESEARCH_INTERESTS = [['Human Physiology', 'human physiology'], ['Circadian/Chronobiology', 'circadian chronobiology'], ['Neurophysiology', 'neurophysiology'], ['Molecular Biology', 'molecular biology'],
                        ['Mathematical Modeling', 'mathematical modeling'], ['Physiology', 'physiology'], ['Neuroanatomy', 'neuroanatomy'], ['Neuropsychiatry', 'neuropsychiatry'], ['Neuropsychology', 'neuropsychology'],
                        ['Learning and Memory', 'learning and memory'], ['Neuropharmacology', 'neuropharmacology'], ['Cardiorespiratory Physiology', 'cardiorespiratory physiology'], ['Upper Airway Muscle Physiology', 'upper airway muscle physiology'],
                        ['Sleep', 'sleep'], ['Genetics of Circadian Clocks', 'genetics of circadian clocks'], ['Other (please specify)', 'other']]

  GENDER = ['Male', 'Female', 'No Response'].collect{|i| [i,i]}
  URM_TYPES = [['Hispanic or Latin', 'hispanic latin'], ['American Indian or Alaska Native', 'americanindian alskanative'], ['Black or African American', 'black africanamerica'], ['Native Hawaiian or Pacific Islander', 'nativehawaiian pacific_islander']]

  serialize :urm_types, Array
  serialize :laboratories, Array
  serialize :transition_position, Array
  serialize :research_interests, Array

  # Callbacks
  before_validation :set_alien_registration_number, :set_password
  before_save :set_submitted_at, :set_tge, :ensure_authentication_token
  before_validation :check_degree_hashes, if: :annual_or_publish?
  after_save :notify_preceptor

  # Named Scopes
  scope :search, -> (arg) { where('LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ? or LOWER(email) LIKE ?', arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%')) }
  scope :submitted_before, -> (arg) { where('applicants.originally_submitted_at < ?', (arg+1.day).at_midnight) }
  scope :submitted_after, -> (arg) { where('applicants.originally_submitted_at >= ?', arg.at_midnight) }
  scope :current_trainee, -> { current.where( enrolled: true, status: 'current' ) }
  scope :supported_by_tg_in_last_fifteen_years, -> { current.where(enrolled: true, supported_by_tg: true).where('training_period_end_date >= ?', Time.zone.today - 15.years) }

  # Model Validation
  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: { scope: :deleted }, allow_blank: true

  validates :expected_year, :degree_sought, presence: true, unless: [:postdoc?, :not_submitted?]
  validates :desired_start_date, :personal_statement, :research_interests, :preferred_preceptor_id, :marital_status,
            presence: true, if: :submitted?
  validates :research_interests_other, presence: true, if: [:submitted?, -> { research_interests.include?("other") }]
  validates :disabled_description, presence: true, if: [:submitted?, :disabled?]
  validates :alien_registration_number, presence: true, if: [:submitted?, :permanent_resident?]
  validates :alien_registration_number, format: { with: /\AA\d*\Z/ }, if: [:submitted?, :permanent_resident?]
  validates :letters_from_a, :letters_from_b, :letters_from_c, presence: true, if: [:submitted?]
  validates :gender, presence: true, if: [:submitted?]

  # Validations required on Annual or Publish State
  # Contact Information
  validates :phone, :address1, :city, :state, :country, :zip_code, presence: true, if: :annual_or_publish?
  # Education Experience
  validates :curriculum_vitae, :current_institution, :department_program, :current_position,
            presence: true, if: :annual_or_publish?
  validates :degree_hashes, presence: true, if: :annual_or_publish?

  # Validations required for Exit Interview
  validates :future_email, :entrance_year, presence: true, if: :termination?
  validates :t32_funded, presence: true, if: [:termination?, -> { t32_funded.nil? }]
  validates :t32_funded_years, presence: true, if: [:termination?, :t32_funded?]
  validates :academic_program_completed, presence: true, if: [:termination?, -> { academic_program_completed.nil? }]
  validates :certificate_application, presence: true, if: [:termination?, :academic_program_completed?]
  validates :research_project_title, :laboratories, presence: true, if: :termination?
  validates :immediate_transition, presence: true, if: [:termination?, -> { immediate_transition.nil? }]
  validates :transition_position, presence: true, if: [:termination?, :immediate_transition?]
  validates :transition_position_other, presence: true, if: [:termination?, :other_position_selected?]

  # Max Length Validation for PostgreSQL strings
  validates :first_name, :last_name, :middle_initial, :current_institution,
            :department_program, :degree_type, :residency, :current_position,
            :address1, :address2, :city, :state, :country, :zip_code, :phone,
            :training_grant_years, :research_project_title, :trainee_code,
            :letters_from_a, :letters_from_b, :letters_from_c, :future_email,
            :transition_position_other, :research_interests_other,
            :research_in_progress_title, :curriculum_advisor,
            length: { maximum: 255 }

  # Model Relationships
  belongs_to :preferred_preceptor, class_name: 'Preceptor', foreign_key: 'preferred_preceptor_id', optional: true
  belongs_to :preferred_preceptor_two, class_name: 'Preceptor', foreign_key: 'preferred_preceptor_two_id', optional: true
  belongs_to :preferred_preceptor_three, class_name: 'Preceptor', foreign_key: 'preferred_preceptor_three_id', optional: true
  belongs_to :primary_preceptor, class_name: 'Preceptor', foreign_key: 'primary_preceptor_id', optional: true
  belongs_to :secondary_preceptor, class_name: 'Preceptor', foreign_key: 'secondary_preceptor_id', optional: true
  has_many :annuals, -> { current.order(year: :desc) }
  has_many :degrees, -> { order :position }
  has_and_belongs_to_many :seminars

  # Applicant Methods

  def avatar_url(size = 80, default = 'mm')
    gravatar_id = Digest::MD5.hexdigest(self.email.to_s.downcase)
    "//gravatar.com/avatar/#{gravatar_id}.png?&s=#{size}&r=pg&d=#{default}"
  end

  def add_seminar(seminar)
    self.seminars << seminar unless seminars.include?(seminar)
  end

  def remove_seminar(seminar)
    self.seminars.delete(seminar)
  end

  def eligible_seminar?(seminar)
    Seminar.current.where(id: seminar.id).where("(DATE(presentation_date) >= ? or ? IS NULL) and (DATE(presentation_date) <= ? or ? IS NULL) and DATE(presentation_date) <= ?", self.training_period_start_date, self.training_period_start_date, self.training_period_end_date, self.training_period_end_date, Time.zone.today).count > 0
  end

  def eligible_seminars(all_seminars)
    Seminar.where(id: all_seminars.collect(&:id)).where("(DATE(presentation_date) >= ? or ? IS NULL) and (DATE(presentation_date) <= ? or ? IS NULL) and DATE(presentation_date) <= ?", self.training_period_start_date, self.training_period_start_date, self.training_period_end_date, self.training_period_end_date, Time.zone.today)
  end

  def seminars_attended(all_seminars)
    seminars.where(id: eligible_seminars(all_seminars).select(:id)).count
  end

  def seminars_attended_percentage(all_seminars)
    if eligible_seminars(all_seminars).count == 0
      0
    else
      seminars_attended(all_seminars) * 100 / eligible_seminars(all_seminars).count
    end
  end

  def degrees_text
    degrees.collect(&:to_text).join("\n")
  end

  def other_position_selected?
    transition_position.include?('other')
  end

  def postdoc?
    applicant_type == 'postdoc'
  end

  def urm_types_names
    URM_TYPES.select { |a, b| urm_types.include?(b) }.collect { |a, b| a }
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

  def name_was
    "#{first_name_was} #{middle_initial_was} #{last_name_was}"
  end

  def reverse_name
    "#{last_name}, #{first_name}"
  end

  def email_with_name
    "#{name} <#{email}>"
  end

  def years_since_training_end_date
    ((Time.zone.today - self.training_period_end_date).day / 1.year).floor
  rescue
    0
  end

  def destroy
    super
    update_column :email, ''
    update_column :updated_at, Time.zone.now
  end

  def set_submitted_at
    if submitted_at.blank? && publish.to_s == '1'
      self.submitted_at = Time.zone.now
      self.originally_submitted_at = submitted_at if originally_submitted_at.blank?
    end
  end

  def set_tge
    self.tge = ['citizen', 'permanent resident'].include?(citizenship_status)
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
    return if encrypted_password.present?
    self.password = Devise.friendly_token
    self.password_confirmation = password
  end

  def check_degree_hashes
    error_found = false
    degree_hashes.each do |hash|
      [:degree_type, :institution].each do |attr|
        if hash[attr].blank?
          errors.add(:degrees, "#{attr.to_s.gsub('_', ' ')} can't be blank") unless errors[:degrees].include?("#{attr.to_s.gsub('_', ' ')} can't be blank")
          error_found = true
        end
      end
      if hash[:year].to_i <= 0
        errors.add(:degrees, "year can't be blank") unless errors[:degrees].include?("year can't be blank")
        error_found = true
      end
    end
    throw :abort if error_found
  end

  # Return true if an email has been sent to the applicant and they have not yet logged in
  def recently_notified?
    emailed_at.present? && current_sign_in_at.present? && current_sign_in_at < emailed_at
  end

  def update_general_information_email!(current_user)
    update_column :emailed_at, Time.zone.now
    UserMailer.update_application(self, current_user).deliver_now if EMAILS_ENABLED
  end

  def send_termination!(current_user)
    update_column :emailed_at, Time.zone.now
    UserMailer.exit_interview(self, current_user).deliver_now if EMAILS_ENABLED
  end

  def degrees_or_params(params)
    params.permit!
    if params[:applicant] && params[:applicant][:degree_hashes].present?
      params[:applicant][:degree_hashes].collect do |hash|
        degrees.new(hash)
      end
    else
      degrees
    end
  end

  def send_annual_reminder_in_background!(current_user, year, subject, body)
    fork_process(:send_annual_reminder!, current_user, year, subject, body)
  end

  def self.send_annual_reminders_in_background!(applicant_scope, current_user, year, subject, body)
    new.fork_process(:send_annual_reminders!, applicant_scope, current_user, year, subject, body)
  end

  protected

  # Override Devise Email Required
  def email_required?
    admin_update != '1'
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

  def send_annual_reminders!(applicant_scope, current_user, year, subject, body)
    applicant_scope.find_each do |applicant|
      applicant.send_annual_reminder!(current_user, year, subject, body)
    end
  end

  private

  def set_degrees
    return unless degree_hashes && degree_hashes.is_a?(Array)
    degrees.destroy_all
    degree_hashes.each_with_index do |hash, index|
      degrees.create(
        position: index,
        degree_type: (Degree::DEGREE_TYPES.collect(&:second).include?(hash[:degree_type]) ? hash[:degree_type] : ''),
        institution: hash[:institution],
        year: hash[:year],
        advisor: hash[:advisor],
        thesis: hash[:thesis],
        concentration_major: hash[:concentration_major]
      )
    end
  end
end
