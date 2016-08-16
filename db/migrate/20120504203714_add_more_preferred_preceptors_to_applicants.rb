class AddMorePreferredPreceptorsToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :preferred_preceptor_two_id, :integer
    add_column :applicants, :preferred_preceptor_three_id, :integer
  end
end
