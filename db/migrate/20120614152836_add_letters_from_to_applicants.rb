class AddLettersFromToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :letters_from_a, :string
    add_column :applicants, :letters_from_b, :string
    add_column :applicants, :letters_from_c, :string
  end
end
