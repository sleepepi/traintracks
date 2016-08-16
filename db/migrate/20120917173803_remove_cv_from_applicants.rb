class RemoveCvFromApplicants < ActiveRecord::Migration[4.2]
  def change
    remove_column :applicants, :cv, :boolean, null: false, default: false
  end
end
