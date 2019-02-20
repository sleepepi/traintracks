class ChangeAnnualIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :annuals, :id, :bigint
  end

  def down
    change_column :annuals, :id, :integer
  end
end
