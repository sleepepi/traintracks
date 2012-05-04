class AddDisabledDescriptionToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :disabled_description, :text
  end
end
