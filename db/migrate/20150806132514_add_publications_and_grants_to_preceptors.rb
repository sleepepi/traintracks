class AddPublicationsAndGrantsToPreceptors < ActiveRecord::Migration
  def change
    add_column :preceptors, :publications, :text
    add_column :preceptors, :grants, :text
  end
end
