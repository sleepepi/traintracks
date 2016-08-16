class AddAdministratorToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :administrator, :boolean, null: false, default: false
  end
end
