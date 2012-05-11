class AddPreviousNsraSupportToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :previous_nsra_support, :boolean, null: false, default: false
  end
end
