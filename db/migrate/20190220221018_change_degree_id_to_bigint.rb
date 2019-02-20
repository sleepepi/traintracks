class ChangeDegreeIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :degrees, :id, :bigint
  end

  def down
    change_column :degrees, :id, :integer
  end
end
