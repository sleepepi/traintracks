class AddReferenceNumberToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :reference_number, :string
  end
end
