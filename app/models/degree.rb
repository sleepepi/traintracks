# frozen_string_literal: true

# Tracks the degrees an applicant has earned over time.
class Degree < ApplicationRecord
  DEGREE_TYPES = [
    ['BA/BS', 'babs'],
    ['MA/MS', 'mams'],
    ['MD/DO', 'mddo'],
    ['PhD/ScD', 'phdscd'],
    ['Other Professional', 'other']
  ]

  # Model Validation

  # Model Relationships
  belongs_to :applicant

  # Model Methods

  def to_text
    "#{degree_type_name} #{institution} #{year} #{advisor} #{thesis} #{concentration_major}"
  end

  def degree_type_name
    DEGREE_TYPES.select { |a, b| degree_type == b }.collect { |a, b| a }.first
  end
end
