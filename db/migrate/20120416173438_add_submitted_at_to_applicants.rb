class AddSubmittedAtToApplicants < ActiveRecord::Migration
  def up
    add_column :applicants, :submitted_at, :datetime
    Applicant.all.each do |applicant|
      unless applicant.year.blank?
        submitted_at = Time.local(applicant.year, "2") # February of the year to avoid timezone year shifts (if it was on Jan 1st)
        applicant.update_attribute :submitted_at, submitted_at
      end
    end
  end

  def down
    remove_column :applicants, :submitted_at
  end
end
