class RemoveAnnualColumnsFromApplicants < ActiveRecord::Migration
  def up
    remove_column :applicants, :pubs_not_prev_rep
    remove_column :applicants, :research_description
    remove_column :applicants, :source_of_support
    remove_column :applicants, :presentations
    remove_column :applicants, :coursework_completed
  end

  def down
    add_column :applicants, :pubs_not_prev_rep, :string
    add_column :applicants, :research_description, :text
    add_column :applicants, :source_of_support, :string
    add_column :applicants, :presentations, :text
    add_column :applicants, :coursework_completed, :text
  end
end
