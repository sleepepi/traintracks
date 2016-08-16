class AddGenderToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :gender, :string
  end
end
