class AddEmailedAtToPreceptors < ActiveRecord::Migration[4.2]
  def change
    add_column :preceptors, :emailed_at, :datetime
  end
end
