class OriginallySubmittedAtToApplicants < ActiveRecord::Migration
  def up
    add_column :applicants, :originally_submitted_at, :datetime
    Applicant.all.each do |applicant|
      applicant.update_column :originally_submitted_at, applicant.submitted_at
    end
  end

  def down
    remove_column :applicants, :originally_submitted_at
  end
end
