class RemovePreviousInstitutionsFromApplicants < ActiveRecord::Migration
  def up
    remove_column :applicants, :previous_institutions
  end

  def down
    add_column :applicants, :previous_institutions, :text
  end
end
