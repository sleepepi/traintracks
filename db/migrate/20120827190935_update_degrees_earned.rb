class UpdateDegreesEarned < ActiveRecord::Migration
  def change
    rename_column :applicants, :degrees_earned, :degrees_earned_old
    add_column :applicants, :degrees_earned, :text
  end
end
