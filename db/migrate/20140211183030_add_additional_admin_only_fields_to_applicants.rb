class AddAdditionalAdminOnlyFieldsToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :curriculum_advisor, :string
    add_column :applicants, :most_recent_curriculum_advisor_meeting_date, :date
    add_column :applicants, :past_curriculum_advisor_meetings, :text
  end
end
