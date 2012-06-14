class AddGenderToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :gender, :string
  end
end
