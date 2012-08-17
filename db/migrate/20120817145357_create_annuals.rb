class CreateAnnuals < ActiveRecord::Migration
  def change
    create_table :annuals do |t|
      t.integer :user_id
      t.integer :applicant_id
      t.integer :year
      t.text :coursework_completed
      t.text :publications
      t.text :presentations
      t.text :research_description
      t.string :source_of_support
      t.string :nih_other_support
      t.datetime :nih_other_support_uploaded_at
      t.datetime :submitted_at
      t.datetime :modified_at
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
  end
end
