class AddEmailedAtToPreceptors < ActiveRecord::Migration
  def change
    add_column :preceptors, :emailed_at, :datetime
  end
end
