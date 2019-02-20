class ChangeApplicantIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :applicants, :id, :bigint

    change_column :applicants_seminars, :applicant_id, :bigint
    change_column :degrees, :applicant_id, :bigint
  end

  def down
    change_column :applicants, :id, :integer

    change_column :applicants_seminars, :applicant_id, :integer
    change_column :degrees, :applicant_id, :integer
  end
end
