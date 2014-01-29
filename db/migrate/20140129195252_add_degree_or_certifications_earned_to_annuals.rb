class AddDegreeOrCertificationsEarnedToAnnuals < ActiveRecord::Migration
  def change
    add_column :annuals, :degree_or_certifications_earned, :text
  end
end
