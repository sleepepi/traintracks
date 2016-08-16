class RemoveDegreesEarnedFromApplicants < ActiveRecord::Migration[5.0]
  def change
    remove_column :applicants, :degrees_earned, :text
  end
end
