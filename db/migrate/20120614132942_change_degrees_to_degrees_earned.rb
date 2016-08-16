class ChangeDegreesToDegreesEarned < ActiveRecord::Migration[4.2]
  def change
    rename_column :applicants, :degrees, :degrees_earned
  end
end
