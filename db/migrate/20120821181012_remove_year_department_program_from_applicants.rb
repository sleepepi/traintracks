class RemoveYearDepartmentProgramFromApplicants < ActiveRecord::Migration
  def up
    remove_column :applicants, :year_department_program
  end

  def down
    add_column :applicants, :year_department_program, :string
  end
end
