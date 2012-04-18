class RenameApplicantNumberToCvNumber < ActiveRecord::Migration
  def change
    rename_column :applicants, :applicant_number, :cv_number
  end
end
