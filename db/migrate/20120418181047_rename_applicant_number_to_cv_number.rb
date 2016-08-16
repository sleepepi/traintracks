class RenameApplicantNumberToCvNumber < ActiveRecord::Migration[4.2]
  def change
    rename_column :applicants, :applicant_number, :cv_number
  end
end
