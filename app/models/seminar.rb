# frozen_string_literal: true

# Provides information about scheduled seminars and trainee attendance.
class Seminar < ActiveRecord::Base
  DURATION_UNITS = %w(minutes hours).collect { |i| [i, i] }

  # Concerns
  include Deletable, Searchable

  # Scopes
  scope :date_before, -> (arg) { where 'presentation_date < ?', (arg + 1.day).at_midnight }
  scope :date_after, -> (arg) { where 'presentation_date >= ?', arg.at_midnight }

  # Model Validation
  validates :category, :presenter, :user_id, presence: true
  validates :duration, numericality: { only_integer: true, greater_than: 0 }

  # Max Length Validation for PostgreSQL strings
  validates :category, :presentation_title, :presenter, length: { maximum: 255 }

  # Model Relationships
  belongs_to :user
  has_and_belongs_to_many :applicants

  # Methods
  def self.searchable_attributes
    %w(presenter presentation_title)
  end

  def name
    "#{category} - #{presenter}"
  end

  def name_was
    "#{category_was} - #{presenter_was}"
  end

  def presentation_date_with_time
    if presentation_date && presentation_date.to_date == presentation_date_end.to_date
      "#{presentation_date.strftime('%b %d, %Y at')} #{time_short(start_time)} to #{time_short(end_time)}"
    elsif presentation_date
      "#{presentation_date.strftime('%b %d, %Y at')} #{time_short(start_time)} to #{presentation_date_end.strftime('%b %d, %Y')} at #{time_short(end_time)}"
    else
      ''
    end
  end

  def presentation_date_end
    presentation_date ? presentation_date + duration.send(duration_units) : nil
  end

  def start_time
    presentation_date.localtime.strftime('%l:%M %p').strip
  end

  def end_time
    presentation_date_end.localtime.strftime('%l:%M %p').strip
  end

  def time_short(time)
    time.gsub(':00', '').gsub(' AM', 'a').gsub(' PM', 'p')
  end
end
