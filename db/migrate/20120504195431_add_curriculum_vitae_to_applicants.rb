class AddCurriculumVitaeToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :curriculum_vitae, :string
    add_column :applicants, :curriculum_vitae_uploaded_at, :datetime
  end
end
