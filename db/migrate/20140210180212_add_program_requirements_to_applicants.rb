class AddProgramRequirementsToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :research_in_progress_title, :string
    add_column :applicants, :research_in_progress_date, :date
    add_column :applicants, :research_in_progress_additional, :text

    add_column :applicants, :research_ethics_training_completed_date, :date
    add_column :applicants, :research_ethics_training_notes, :text

    add_column :applicants, :grant_writing_training_completed_date, :date
    add_column :applicants, :basic_research_statistics_course_completed_date, :date
    add_column :applicants, :advanced_research_statistics_course_completed_date, :date
    add_column :applicants, :neuroscience_course_completed_date, :date
    add_column :applicants, :hsoph_summer_session_course_completed_date, :date
    add_column :applicants, :individual_funding_submission_date, :date
    add_column :applicants, :individual_funding_type, :text
    add_column :applicants, :last_idp_date, :date
  end
end
