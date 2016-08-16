class AddFileUploadsToPreceptors < ActiveRecord::Migration[4.2]
  def change
    add_column :preceptors, :biosketch, :string
    add_column :preceptors, :curriculum_vitae, :string
  end
end
