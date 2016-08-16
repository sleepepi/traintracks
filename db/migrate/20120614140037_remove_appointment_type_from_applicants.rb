class RemoveAppointmentTypeFromApplicants < ActiveRecord::Migration[4.2]
  def change
    remove_column :applicants, :appointment_type, :string
  end
end
