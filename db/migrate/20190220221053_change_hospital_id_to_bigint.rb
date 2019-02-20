class ChangeHospitalIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :hospitals, :id, :bigint, auto_increment: true
  end

  def down
    change_column :hospitals, :id, :integer, auto_increment: true
  end
end
