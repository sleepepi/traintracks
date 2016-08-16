class RenameCurrentTitleToCurrentPositionForApplicants < ActiveRecord::Migration[4.2]
  def change
    rename_column :applicants, :current_title, :current_position
  end
end
