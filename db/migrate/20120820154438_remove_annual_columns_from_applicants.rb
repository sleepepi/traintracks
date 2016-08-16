class RemoveAnnualColumnsFromApplicants < ActiveRecord::Migration[4.2]
  def change
    remove_column :applicants, :pubs_not_prev_rep, :string
    remove_column :applicants, :research_description, :text
    remove_column :applicants, :source_of_support, :string
    remove_column :applicants, :presentations, :text
    remove_column :applicants, :coursework_completed, :text
  end
end
