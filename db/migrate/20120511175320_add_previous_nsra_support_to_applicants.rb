class AddPreviousNsraSupportToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :previous_nsra_support, :boolean, null: false, default: false
  end
end
