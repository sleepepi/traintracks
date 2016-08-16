class AddEmailedAtToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :emailed_at, :datetime
  end
end
