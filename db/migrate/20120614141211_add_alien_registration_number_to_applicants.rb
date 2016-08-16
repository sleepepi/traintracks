class AddAlienRegistrationNumberToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :alien_registration_number, :string
  end
end
