class Annual < ActiveRecord::Base
  # attr_accessible :applicant_id, :coursework_completed, :nih_other_support, :nih_other_support_uploaded_at, :nih_other_support_cache, :presentations, :publications, :research_description, :source_of_support, :year, :publish, :user_id

  attr_accessor :publish

  mount_uploader :nih_other_support, DocumentUploader

  # Callbacks
  before_save :set_submitted_at

  # Concerns
  include Deletable

  # Named Scopes
  scope :search, lambda { |arg| where( 'annuals.applicant_id in (select applicants.id from applicants where LOWER(applicants.first_name) LIKE ? or LOWER(applicants.last_name) LIKE ? or LOWER(applicants.email) LIKE ?)', arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%') ).references(:applicants) }

  # Model Validation
  validates_presence_of :applicant_id, :user_id, :year
  validates_uniqueness_of :year, scope: [:applicant_id, :deleted]
  validates_presence_of :coursework_completed, :nih_other_support, :presentations, :publications, :research_description, :source_of_support, if: [:publish?]


  # Model Relationships
  belongs_to :applicant
  belongs_to :user

  # Annual Methods

  def name
    "#{self.year}"
  end

  def publish?
    self.publish == '1'
  end

  def set_submitted_at
    if self.publish.to_s == '1'
      self.modified_at = Time.now
      self.submitted_at = self.modified_at if self.submitted_at.blank?
    end
  end

  def submitted?
    not self.submitted_at.blank?
  end

end
