class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :encryptable, :confirmable, :lockable and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Callbacks
  after_create :notify_system_admins

  STATUS = ["active", "denied", "inactive", "pending"].collect{|i| [i,i]}

  # Concerns
  include Contourable

  # Named Scopes
  scope :current, -> { where deleted: false }
  scope :status, lambda { |arg|  where( status: arg ) }
  scope :search, lambda { |arg| where( 'LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ? or LOWER(email) LIKE ?', arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%') ) }
  scope :system_admins, -> { where system_admin: true }
  scope :administrators, -> { where administrator: true }

  # Model Validation
  validates_presence_of :first_name, :last_name

  # Model Relationships
  has_many :authentications
  has_many :annuals, -> { where deleted: false }
  has_many :seminars, -> { where deleted: false }

  # User Methods
  # Overriding Devise built-in active_for_authentication? method
  def active_for_authentication?
    super and self.status == 'active' and not self.deleted?
  end

  def destroy
    update_column :deleted, true
    update_column :status, 'inactive'
    update_column :updated_at, Time.now
  end

  # def email_on?(value)
  #   [nil, true].include?(self.email_notifications[value.to_s])
  # end

  def all_annuals
    @all_annuals ||= begin
      Annual.current
    end
  end

  def all_viewable_annuals
    @all_viewble_annuals ||= begin
      self.all_annuals
    end
  end

  def all_seminars
    @all_seminars ||= begin
      Seminar.current
    end
  end

  def all_viewable_seminars
    @all_viewable_seminars ||= begin
      self.all_seminars
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def reverse_name
    "#{last_name}, #{first_name}"
  end

  # Override of Contourable
  def apply_omniauth(omniauth)
    unless omniauth['info'].blank?
      self.first_name = omniauth['info']['first_name'] if first_name.blank?
      self.last_name = omniauth['info']['last_name'] if last_name.blank?
    end
    super
  end

  private

  def notify_system_admins
    User.current.system_admins.each do |system_admin|
      UserMailer.notify_system_admin(system_admin, self).deliver if Rails.env.production?
    end
  end
end
