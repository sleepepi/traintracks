class ChangeAnnualIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :annuals, :id, :bigint, auto_increment: true
  end

  def down
    change_column :annuals, :id, :integer, auto_increment: true
  end
end
