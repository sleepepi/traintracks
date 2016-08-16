class AddDegreeTypesToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :degree_types, :text
  end
end
