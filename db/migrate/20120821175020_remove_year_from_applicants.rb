class RemoveYearFromApplicants < ActiveRecord::Migration[4.2]
  def change
    remove_column :applicants, :year, :integer
  end
end
