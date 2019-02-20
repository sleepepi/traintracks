class ChangePreceptorIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :preceptors, :id, :bigint, auto_increment: true

    change_column :applicants, :preferred_preceptor_id, :bigint
    change_column :applicants, :primary_preceptor_id, :bigint
    change_column :applicants, :secondary_preceptor_id, :bigint
  end

  def down
    change_column :preceptors, :id, :integer, auto_increment: true

    change_column :applicants, :preferred_preceptor_id, :integer
    change_column :applicants, :primary_preceptor_id, :integer
    change_column :applicants, :secondary_preceptor_id, :integer
  end
end
