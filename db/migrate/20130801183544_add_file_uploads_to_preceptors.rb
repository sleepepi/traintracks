class AddFileUploadsToPreceptors < ActiveRecord::Migration
  def change
    add_column :preceptors, :biosketch, :string
    add_column :preceptors, :curriculum_vitae, :string
  end
end
