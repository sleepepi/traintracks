class AddEraCommonsUsernameToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :era_commons_username, :string
  end
end
