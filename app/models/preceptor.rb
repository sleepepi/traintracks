class Preceptor < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :encryptable and :omniauthable, :registerable
  devise :database_authenticatable, :timeoutable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :lockable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  # attr_accessible :degree, :deleted, :first_name, :hospital_affiliation, :hospital_appointment, :last_name, :program_role, :rank, :research_interest, :status,
  #                 :other_support, :other_support_cache

  mount_uploader :other_support, DocumentUploader
  mount_uploader :biosketch, DocumentUploader
  mount_uploader :curriculum_vitae, DocumentUploader

  STATUS = ["current", "former"].collect{|i| [i,i]}
  RANK = ["Associate Preceptor", "Full Preceptor"].collect{|i| [i,i]}

  # Callbacks
  before_validation :set_password

  # Named Scopes
  scope :current, -> { where deleted: false }
  scope :search, lambda { |arg| where( 'LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ?', arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%') ) }

  # Model Validation
  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :email, allow_blank: true, scope: :deleted

  # Model Relationships
  # has_many :applicants

  # Preceptor Methods

  def name_with_id
    "#{self.id}: #{self.name}"
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
    "#{first_name} #{last_name}"
  end

  def reverse_name
    "#{last_name}, #{first_name}"
  end

  def destroy
    update_column :deleted, true
    update_column :email, ''
  end

  # Return true if an email has been sent to the applicant and they have not yet logged in
  def recently_notified?
    not self.emailed_at.blank? and not self.current_sign_in_at.blank? and self.current_sign_in_at < self.emailed_at
  end

  def update_general_information_email!(current_user)
    self.reset_authentication_token!
    self.update_column :emailed_at, Time.now
    UserMailer.update_preceptor(self, current_user).deliver if Rails.env.production?
  end

  def set_password
    if self.respond_to?('encrypted_password') and self.encrypted_password.blank?
      self.password = Applicant.reset_password_token
      self.password_confirmation = self.password
    end
    true
  end

end
