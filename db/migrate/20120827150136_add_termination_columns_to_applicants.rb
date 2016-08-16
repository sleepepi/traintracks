class AddTerminationColumnsToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :future_email, :string
    add_column :applicants, :entrance_year, :integer
    add_column :applicants, :t32_funded, :boolean
    add_column :applicants, :t32_funded_years, :integer
    add_column :applicants, :academic_program_completed, :boolean
    add_column :applicants, :certificate_application, :string
    add_column :applicants, :laboratories, :text
    add_column :applicants, :immediate_transition, :boolean
    add_column :applicants, :transition_position, :text
    add_column :applicants, :transition_position_other, :string
    add_column :applicants, :termination_feedback, :text
  end
end
