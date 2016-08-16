class AddIndicesToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_index :applicants, :email #,                unique: true
    add_index :applicants, :reset_password_token, unique: true
    add_index :applicants, :confirmation_token,   unique: true
    add_index :applicants, :unlock_token,         unique: true
    add_index :applicants, :authentication_token, unique: true
  end
end
