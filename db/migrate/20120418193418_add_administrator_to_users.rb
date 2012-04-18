class AddAdministratorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :administrator, :boolean, null: false, default: false
  end
end
