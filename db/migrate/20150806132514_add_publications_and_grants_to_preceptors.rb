class AddPublicationsAndGrantsToPreceptors < ActiveRecord::Migration[4.2]
  def change
    add_column :preceptors, :publications, :text
    add_column :preceptors, :grants, :text
  end
end
