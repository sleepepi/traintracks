class AddDegreeOrCertificationsEarnedToAnnuals < ActiveRecord::Migration[4.2]
  def change
    add_column :annuals, :degree_or_certifications_earned, :text
  end
end
