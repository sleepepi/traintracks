class RenameCurrentTitleToCurrentPositionForApplicants < ActiveRecord::Migration
  def change
    rename_column :applicants, :current_title, :current_position
  end
end
