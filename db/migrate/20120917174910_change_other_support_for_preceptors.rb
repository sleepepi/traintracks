class ChangeOtherSupportForPreceptors < ActiveRecord::Migration[4.2]
  def up
    change_column :preceptors, :other_support, :string, null: true, default: nil
  end

  def down
    change_column :preceptors, :other_support, :boolean, null: false, default: false
  end
end
