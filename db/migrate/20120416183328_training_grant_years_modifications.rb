class TrainingGrantYearsModifications < ActiveRecord::Migration
  def up
    remove_column :applicants, :grant_years
    rename_column :applicants, :tg_years, :training_grant_years
  end

  def down
    add_column :applicants, :grant_years, :string
    rename_column :applicants, :training_grant_years, :tg_years
  end
end
