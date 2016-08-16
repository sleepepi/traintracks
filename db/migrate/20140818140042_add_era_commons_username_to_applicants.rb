class AddEraCommonsUsernameToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :era_commons_username, :string
  end
end
