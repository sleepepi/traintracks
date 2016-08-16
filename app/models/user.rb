# frozen_string_literal: true

# The user class provides methods to scope resources in system that the user is
# allowed to view and edit.
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :encryptable, :confirmable, :lockable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Callbacks
  after_create_commit :notify_system_admins

  STATUS = %w(active denied inactive pending).collect { |i| [i, i] }

  # Concerns
  include Deletable, Searchable

  # Named Scopes
  scope :system_admins, -> { where system_admin: true }

  # Model Validation
  validates :first_name, :last_name, presence: true

  # Model Relationships
  has_many :authentications
  has_many :annuals, -> { current }
  has_many :seminars, -> { current }

  # Model Methods
  def self.searchable_attributes
    %w(first_name last_name email)
  end

  def avatar_url(size = 80, default = 'mm')
    gravatar_id = Digest::MD5.hexdigest(email.to_s.downcase)
    "//gravatar.com/avatar/#{gravatar_id}.png?&s=#{size}&r=pg&d=#{default}"
  end

  # Overriding Devise built-in active_for_authentication? method
  def active_for_authentication?
    super && status == 'active' && !deleted?
  end

  def devise_path
    ''
  end

  def destroy
    super
    update_column :status, 'inactive'
    update_column :updated_at, Time.zone.now
  end

  # def email_on?(value)
  #   [nil, true].include?(self.email_notifications[value.to_s])
  # end

  def all_annuals
    Annual.current
  end

  def all_viewable_annuals
    all_annuals
  end

  def all_seminars
    Seminar.current
  end

  def all_viewable_seminars
    all_seminars
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name_was
    "#{first_name_was} #{last_name_was}"
  end

  def reverse_name
    "#{last_name}, #{first_name}"
  end

  private

  def notify_system_admins
    return unless EMAILS_ENABLED
    User.current.system_admins.each do |system_admin|
      UserMailer.notify_system_admin(system_admin, self).deliver_now
    end
  end
end
