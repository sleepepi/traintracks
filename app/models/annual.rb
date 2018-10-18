# frozen_string_literal: true

# Tracks annual updates for applicants.
class Annual < ApplicationRecord
  attr_accessor :publish

  mount_uploader :nih_other_support, DocumentUploader

  # Callbacks
  before_save :set_submitted_at

  # Concerns
  include Deletable, Forkable

  # Named Scopes
  scope :search, -> (arg) { where('annuals.applicant_id in (select applicants.id from applicants where LOWER(applicants.first_name) LIKE ? or LOWER(applicants.last_name) LIKE ? or LOWER(applicants.email) LIKE ?)', arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%')).references(:applicants) }

  # Model Validation
  validates :year, presence: true
  validates :year, uniqueness: { scope: [:applicant_id, :deleted] }
  validates :coursework_completed, :presentations, :publications,
            :research_description, :source_of_support,
            presence: true, if: [:publish?]
  validates :source_of_support, length: { maximum: 255 }

  # Model Relationships
  belongs_to :applicant
  belongs_to :user

  # Annual Methods

  def name
    year.to_s
  end

  def name_was
    year_was.to_s
  end

  def publish?
    publish == '1'
  end

  def set_submitted_at
    return unless publish.to_s == '1'
    self.modified_at = Time.zone.now
    self.submitted_at = modified_at if submitted_at.blank?
  end

  def submitted?
    submitted_at.present?
  end

  def send_annual_submitted_in_background!
    fork_process(:send_annual_submitted!)
  end

  protected

  def send_annual_submitted!
    return unless EMAILS_ENABLED
    UserMailer.annual_submitted(self).deliver_now
  end
end
