class AddAssuranceToApplicant < ActiveRecord::Migration
  def change
    add_column :applicants, :assurance, :boolean, null: false, default: false
  end
end
