class AddMaritalStatusToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :marital_status, :string
  end
end
