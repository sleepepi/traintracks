class ChangeUserIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :id, :bigint, auto_increment: true

    change_column :annuals, :user_id, :bigint
    change_column :seminars, :user_id, :bigint
  end

  def down
    change_column :users, :id, :integer, auto_increment: true

    change_column :annuals, :user_id, :integer
    change_column :seminars, :user_id, :integer
  end
end
