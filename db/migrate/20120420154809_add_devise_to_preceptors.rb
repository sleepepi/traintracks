class AddDeviseToPreceptors < ActiveRecord::Migration
    def change
    # Database authenticatable
    add_column :preceptors, :email, :string, null: false, default: ""
    add_column :preceptors, :encrypted_password, :string, null: false, default: ""

    # Recoverable
    add_column :preceptors, :reset_password_token, :string
    add_column :preceptors, :reset_password_sent_at, :datetime

    # Rememberable
    add_column :preceptors, :remember_created_at, :datetime

    # Trackable
    add_column :preceptors, :sign_in_count, :integer, default: 0
    add_column :preceptors, :current_sign_in_at, :datetime
    add_column :preceptors, :last_sign_in_at, :datetime
    add_column :preceptors, :current_sign_in_ip, :string
    add_column :preceptors, :last_sign_in_ip, :string

    # Encryptable
    add_column :preceptors, :password_salt, :string

    # Confirmable
    add_column :preceptors, :confirmation_token, :string
    add_column :preceptors, :confirmed_at, :datetime
    add_column :preceptors, :confirmation_sent_at, :datetime
    add_column :preceptors, :unconfirmed_email, :string # Only if using reconfirmable

    # Lockable
    add_column :preceptors, :failed_attempts, :integer, default: 0 # Only if lock strategy is :failed_attempts
    add_column :preceptors, :unlock_token, :string # Only if unlock strategy is :email or :both
    add_column :preceptors, :locked_at, :datetime

    # Token authenticatable
    add_column :preceptors, :authentication_token, :string

    add_index :preceptors, :email #,                unique: true
    add_index :preceptors, :reset_password_token, unique: true
    add_index :preceptors, :confirmation_token,   unique: true
    add_index :preceptors, :unlock_token,         unique: true
    add_index :preceptors, :authentication_token, unique: true
  end
end
