class ChangeDegreesToDegreesEarned < ActiveRecord::Migration
  def change
    rename_column :applicants, :degrees, :degrees_earned
  end
end
