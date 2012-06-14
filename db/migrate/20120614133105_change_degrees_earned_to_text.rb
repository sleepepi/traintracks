class ChangeDegreesEarnedToText < ActiveRecord::Migration
  def up
    change_column :applicants, :degrees_earned, :text
  end

  def down
    change_column :applicants, :degrees_earned, :string
  end
end
