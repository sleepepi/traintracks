class AddSubmittedAtToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :submitted_at, :datetime
    add_column :applicants, :assurance, :boolean, null: false, default: false
  end
end
