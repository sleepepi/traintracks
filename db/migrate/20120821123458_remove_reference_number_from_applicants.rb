class RemoveReferenceNumberFromApplicants < ActiveRecord::Migration
  def up
    remove_column :applicants, :reference_number
  end

  def down
    add_column :applicants, :reference_number, :string
  end
end
