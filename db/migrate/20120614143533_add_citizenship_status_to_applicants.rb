class AddCitizenshipStatusToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :citizenship_status, :string, null: false, default: 'noncitizen'
  end
end
