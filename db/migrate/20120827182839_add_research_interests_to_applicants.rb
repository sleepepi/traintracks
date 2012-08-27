class AddResearchInterestsToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :research_interests, :text
    add_column :applicants, :research_interests_other, :string
  end
end
