class TrainingGrantYearsModifications < ActiveRecord::Migration[4.2]
  def change
    remove_column :applicants, :grant_years, :string
    rename_column :applicants, :tg_years, :training_grant_years
  end
end
