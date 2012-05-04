class AddPersonalStatementToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :personal_statement, :text
  end
end
