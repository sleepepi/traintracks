class Hospital < ActiveRecord::Base

  # Concerns
  include Deletable

  # Scopes
  scope :search, lambda { |arg| where( "LOWER(name) LIKE ?", arg.to_s.downcase.gsub(/^| |$/, '%') ) }

  # Model Validation
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :deleted

end
