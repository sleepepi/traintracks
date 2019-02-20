class ChangeHospitalIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :hospitals, :id, :bigint
  end

  def down
    change_column :hospitals, :id, :integer
  end
end
