class RenameNsraToNrsa < ActiveRecord::Migration[4.2]
  def change
    rename_column :applicants, :previous_nsra_support, :previous_nrsa_support
  end
end
