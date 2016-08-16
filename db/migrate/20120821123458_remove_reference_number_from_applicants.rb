class RemoveReferenceNumberFromApplicants < ActiveRecord::Migration[4.2]
  def change
    remove_column :applicants, :reference_number, :string
  end
end
