class RemoveAppointmentTypeFromApplicants < ActiveRecord::Migration
  def up
    remove_column :applicants, :appointment_type
  end

  def down
    add_column :applicants, :appointment_type, :string
  end
end
