class ChangeForeignKeyIdsToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :annuals, :applicant_id, :bigint
    change_column :applicants, :preferred_preceptor_two_id, :bigint
    change_column :applicants, :preferred_preceptor_three_id, :bigint
  end

  def down
    change_column :annuals, :applicant_id, :integer
    change_column :applicants, :preferred_preceptor_two_id, :integer
    change_column :applicants, :preferred_preceptor_three_id, :integer
  end
end
