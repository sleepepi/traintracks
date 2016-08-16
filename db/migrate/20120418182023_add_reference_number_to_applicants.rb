class AddReferenceNumberToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :reference_number, :string
  end
end
