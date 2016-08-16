class AddPersonalStatementToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :personal_statement, :text
  end
end
