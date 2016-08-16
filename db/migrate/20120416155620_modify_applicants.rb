class ModifyApplicants < ActiveRecord::Migration[4.2]
  def change
    remove_column :applicants, :fax, :string
    rename_column :applicants, :current_position_or_source_of_support, :current_title
    rename_column :applicants, :coursework_comp, :coursework_completed
    add_column :applicants, :desired_start_date, :date
  end
end
