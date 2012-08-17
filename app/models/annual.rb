class Annual < ActiveRecord::Base
  attr_accessible :applicant_id, :coursework_completed, :nih_other_support, :nih_other_support_uploaded_at, :nih_other_support_cache, :presentations, :publications, :research_description, :source_of_support, :year, :publish

  attr_accessor :publish

  mount_uploader :nih_other_support, DocumentUploader

  # Callbacks
  before_save :set_submitted_at

  # Named Scopes
  scope :current, conditions: { deleted: false }

  # Model Validation
  validates_presence_of :applicant_id, :user_id, :year
  validates_uniqueness_of :year, scope: [:applicant_id, :deleted]

  # Model Relationships
  belongs_to :applicant
  belongs_to :user

  # Annual Methods

  def name
    "#{self.year}"
  end

  def destroy
    update_column :deleted, true
  end

  def set_submitted_at
    if self.publish.to_s == '1'
      self.modified_at = Time.now
      self.submitted_at = self.modified_at if self.submitted_at.blank?
    end
  end

end
