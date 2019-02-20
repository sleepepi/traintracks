class ChangeDegreeIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :degrees, :id, :bigint, auto_increment: true
  end

  def down
    change_column :degrees, :id, :integer, auto_increment: true
  end
end
