class RemoveCvFromApplicants < ActiveRecord::Migration
  def up
    remove_column :applicants, :cv
  end

  def down
    add_column :applicants, :cv, :boolean, null: false, default: false
  end
end
