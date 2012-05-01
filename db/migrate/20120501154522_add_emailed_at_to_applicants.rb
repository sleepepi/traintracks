class AddEmailedAtToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :emailed_at, :datetime
  end
end
