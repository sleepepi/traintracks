class Preceptor < ActiveRecord::Base

  STATUS = ["current", "former"].collect{|i| [i,i]}

  attr_accessible :degree, :deleted, :first_name, :hospital_affiliation, :hospital_appointment, :last_name, :other_support, :program_role, :rank, :research_interest, :status

  # Named Scopes
  scope :current, conditions: { deleted: false }
  scope :search, lambda { |*args| { conditions: [ 'LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ?', '%' + args.first.downcase.split(' ').join('%') + '%', '%' + args.first.downcase.split(' ').join('%') + '%' ] } }

  # Model Validation
  validates_presence_of :first_name, :last_name

  # Model Relationships
  # has_many :applicants

  # Preceptor Methods

  def name
    "#{first_name} #{last_name}"
  end

  def reverse_name
    "#{last_name}, #{first_name}"
  end

  def destroy
    update_attribute :deleted, true
  end

end
