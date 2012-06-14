class AddUrmTypesToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :urm_types, :text
  end
end
