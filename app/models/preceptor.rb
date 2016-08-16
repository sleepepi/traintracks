# frozen_string_literal: true

# The preceptor class provides methods to to access information about preceptors
# and allows preceptors to be connected to applicants and trainees.
class Preceptor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :encryptable and :omniauthable, :registerable
  devise :database_authenticatable, :timeoutable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  # Concerns
  include TokenAuthenticatable, Deletable, Searchable

  mount_uploader :other_support, DocumentUploader
  mount_uploader :biosketch, DocumentUploader
  mount_uploader :curriculum_vitae, DocumentUploader

  STATUS = %w(current former).collect { |i| [i, i] }
  RANK = ['Associate Preceptor', 'Full Preceptor'].collect { |i| [i, i] }

  # Callbacks
  before_validation :set_password
  before_save :ensure_authentication_token

  # Model Validation
  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: { scope: :deleted }, allow_blank: true

  # Max Length Validation for PostgreSQL strings
  validates :first_name, :last_name, :degree, :hospital_affiliation,
            :hospital_appointment, :program_role, length: { maximum: 255 }

  # Model Relationships
  # has_many :applicants

  # Model Methods
  def self.searchable_attributes
    %w(first_name last_name)
  end

  def avatar_url(size = 80, default = 'mm')
    gravatar_id = Digest::MD5.hexdigest(email.to_s.downcase)
    "//gravatar.com/avatar/#{gravatar_id}.png?&s=#{size}&r=pg&d=#{default}"
  end

  def name_with_id
    "#{id}: #{name}"
  end

  # Overriding Devise built-in active_for_authentication? method
  def active_for_authentication?
    super && !deleted?
  end

  def devise_path
    'preceptor/'
  end

  def name
    "#{first_name} #{last_name}"
  end

  def reverse_name
    "#{last_name}, #{first_name}"
  end

  def destroy
    super
    update_column :email, ''
    update_column :updated_at, Time.zone.now
  end

  # Return true if an email has been sent to the applicant and they have not yet logged in
  def recently_notified?
    emailed_at.present? && current_sign_in_at.present? && current_sign_in_at < emailed_at
  end

  def update_general_information_email!(current_user)
    update_column :emailed_at, Time.zone.now
    UserMailer.update_preceptor(self, current_user).deliver_now if EMAILS_ENABLED
  end

  def set_password
    if respond_to?('encrypted_password') && encrypted_password.blank?
      self.password = Devise.friendly_token
      self.password_confirmation = password
    end
    true
  end
end
