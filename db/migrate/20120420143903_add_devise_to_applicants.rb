class AddDeviseToApplicants < ActiveRecord::Migration
  def change
    # Database authenticatable
    add_column :applicants, :encrypted_password, :string, null: false, default: ""

    # Recoverable
    add_column :applicants, :reset_password_token, :string
    add_column :applicants, :reset_password_sent_at, :datetime

    # Rememberable
    add_column :applicants, :remember_created_at, :datetime

    # Trackable
    add_column :applicants, :sign_in_count, :integer, default: 0
    add_column :applicants, :current_sign_in_at, :datetime
    add_column :applicants, :last_sign_in_at, :datetime
    add_column :applicants, :current_sign_in_ip, :string
    add_column :applicants, :last_sign_in_ip, :string

    # Encryptable
    add_column :applicants, :password_salt, :string

    # Confirmable
    add_column :applicants, :confirmation_token, :string
    add_column :applicants, :confirmed_at, :datetime
    add_column :applicants, :confirmation_sent_at, :datetime
    add_column :applicants, :unconfirmed_email, :string # Only if using reconfirmable

    # Lockable
    add_column :applicants, :failed_attempts, :integer, default: 0 # Only if lock strategy is :failed_attempts
    add_column :applicants, :unlock_token, :string # Only if unlock strategy is :email or :both
    add_column :applicants, :locked_at, :datetime

    # Token authenticatable
    add_column :applicants, :authentication_token, :string
  end
end
