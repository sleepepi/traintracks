class AddDegreeTypesToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :degree_types, :text
  end
end
