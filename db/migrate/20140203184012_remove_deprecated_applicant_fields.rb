class RemoveDeprecatedApplicantFields < ActiveRecord::Migration
  def change
    remove_column :applicants, :degrees_earned_old, :text
    remove_column :applicants, :concentration_major, :string
    remove_column :applicants, :advisor, :string
    remove_column :applicants, :thesis, :string
    remove_column :applicants, :degree_types, :text
  end
end
