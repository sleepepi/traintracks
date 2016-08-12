# frozen_string_literal: true

# Helps popuplate list of hospitals.
class Hospital < ActiveRecord::Base
  # Concerns
  include Deletable, Searchable

  # Model Validation
  validates :name, presence: true, uniqueness: { scope: :deleted }

  # Model Methods
  def self.searchable_attributes
    %w(name)
  end
end
