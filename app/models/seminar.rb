class Seminar < ActiveRecord::Base
  attr_accessible :category, :duration, :duration_units, :presentation_date, :presentation_title, :presenter

  DURATION_UNITS = ['minutes', 'hours'].collect{|i| [i,i]}

  # Concerns
  include Deletable

  # Scopes
  scope :search, lambda { |arg| where('LOWER(presenter) LIKE ? or LOWER(presentation_title) LIKE ?', arg.downcase.gsub(/^| |$/, '%'), arg.downcase.gsub(/^| |$/, '%')) }
  scope :date_before, lambda { |*args| { conditions: ["presentation_date < ?", (args.first+1.day).at_midnight]} }
  scope :date_after, lambda { |*args| { conditions: ["presentation_date >= ?", args.first.at_midnight]} }

  # Model Validation
  validates_presence_of :category, :presenter, :user_id
  validates_numericality_of :duration, only_integer: true, greater_than: 0

  # Model Relationships
  belongs_to :user
  has_and_belongs_to_many :applicants

  # Methods

  def name
    "#{self.category} - #{self.presenter}"
  end

  def presentation_date_with_time
    result = ""
    result = if self.presentation_date and self.presentation_date.to_date == self.presentation_date_end.to_date
      "#{self.presentation_date.strftime("%b %d, %Y at")} #{time_short(self.start_time)} to #{time_short(self.end_time)}"
    else
      "#{self.presentation_date.strftime("%b %d, %Y at")} #{time_short(self.start_time)} to #{self.presentation_date_end.strftime("%b %d, %Y")} at #{time_short(self.end_time)}"
    end
    result
  end

  def presentation_date_end
    self.presentation_date ? self.presentation_date + (self.duration).send(self.duration_units) : nil
  end

  def start_time
    self.presentation_date.localtime.strftime("%l:%M %p").strip
  end

  def end_time
    self.presentation_date_end.localtime.strftime("%l:%M %p").strip
  end

  def time_short(time)
    time.gsub(':00', '').gsub(' AM', 'a').gsub(' PM', 'p')
  end

end
