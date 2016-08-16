class AddResearchInterestsToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :research_interests, :text
    add_column :applicants, :research_interests_other, :string
  end
end
