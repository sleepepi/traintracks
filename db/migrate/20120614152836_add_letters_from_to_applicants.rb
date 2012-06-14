class AddLettersFromToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :letters_from_a, :string
    add_column :applicants, :letters_from_b, :string
    add_column :applicants, :letters_from_c, :string
  end
end
