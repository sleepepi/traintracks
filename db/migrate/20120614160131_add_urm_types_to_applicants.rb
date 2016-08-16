class AddUrmTypesToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :urm_types, :text
  end
end
