class AddMaritalStatusToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :marital_status, :string
  end
end
