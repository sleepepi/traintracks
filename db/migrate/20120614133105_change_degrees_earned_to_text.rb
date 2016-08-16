class ChangeDegreesEarnedToText < ActiveRecord::Migration[4.2]
  def up
    change_column :applicants, :degrees_earned, :text
  end

  def down
    change_column :applicants, :degrees_earned, :string
  end
end
