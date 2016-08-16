class AddDisabledDescriptionToApplicants < ActiveRecord::Migration[4.2]
  def change
    add_column :applicants, :disabled_description, :text
  end
end
