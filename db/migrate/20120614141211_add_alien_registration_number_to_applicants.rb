class AddAlienRegistrationNumberToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :alien_registration_number, :string
  end
end
