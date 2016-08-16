class AddCitizenshipStatusToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :citizenship_status, :string, null: false, default: 'noncitizen'
  end
end
