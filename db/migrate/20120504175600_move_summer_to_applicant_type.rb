class MoveSummerToApplicantType < ActiveRecord::Migration[4.2]
  def change
    remove_column :applicants, :summer, :boolean, null: false, default: false
  end
end
