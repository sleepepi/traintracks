class MoveSummerToApplicantType < ActiveRecord::Migration
  def up
    Applicant.where(summer: true).update_all(applicant_type: 'summer')
    remove_column :applicants, :summer
  end

  def down
    add_column :applicants, :summer, :boolean, null: false, default: false
    Applicant.where(applicant_type: 'summer').update_all(summer: true)
  end
end
