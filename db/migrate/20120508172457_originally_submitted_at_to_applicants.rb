class OriginallySubmittedAtToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :originally_submitted_at, :datetime
  end
end
