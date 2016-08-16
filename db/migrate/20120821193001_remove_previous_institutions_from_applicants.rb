class RemovePreviousInstitutionsFromApplicants < ActiveRecord::Migration[4.2]
  def change
    remove_column :applicants, :previous_institutions, :text
  end
end
