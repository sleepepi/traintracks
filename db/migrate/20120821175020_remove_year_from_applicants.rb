class RemoveYearFromApplicants < ActiveRecord::Migration
  def up
    remove_column :applicants, :year
  end

  def down
    add_column :applicants, :year, :integer
  end
end
