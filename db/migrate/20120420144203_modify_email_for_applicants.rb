class ModifyEmailForApplicants < ActiveRecord::Migration
  def up
    change_column :applicants, :email, :string, null: false, default: ""
  end

  def down
    change_column :applicants, :email, :string, null: true, default: nil
  end
end
