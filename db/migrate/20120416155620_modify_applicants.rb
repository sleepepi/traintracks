class ModifyApplicants < ActiveRecord::Migration
  def up
    remove_column :applicants, :fax
    rename_column :applicants, :current_position_or_source_of_support, :current_title
    rename_column :applicants, :coursework_comp, :coursework_completed
    add_column :applicants, :desired_start_date, :date
  end

  def down
    add_column :applicants, :fax, :string
    rename_column :applicants, :current_title, :current_position_or_source_of_support
    rename_column :applicants, :coursework_completed, :coursework_comp
    remove_column :applicants, :desired_start_date
  end
end
