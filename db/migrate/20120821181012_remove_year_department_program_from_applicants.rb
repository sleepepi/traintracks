class RemoveYearDepartmentProgramFromApplicants < ActiveRecord::Migration[4.2]
  def change
    remove_column :applicants, :year_department_program, :string
  end
end
