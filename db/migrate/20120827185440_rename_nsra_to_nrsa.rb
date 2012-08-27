class RenameNsraToNrsa < ActiveRecord::Migration
  def change
    rename_column :applicants, :previous_nsra_support, :previous_nrsa_support
  end
end
