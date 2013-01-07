class CreateSeminars < ActiveRecord::Migration
  def change
    create_table :seminars do |t|
      t.string :category
      t.string :presenter
      t.string :presentation_title
      t.datetime :presentation_date
      t.integer :duration, null: false, default: 1
      t.string :duration_units, null: false, default: 'hours'
      t.integer :user_id
      t.boolean :deleted, default: false, null: false

      t.timestamps
    end

    add_index :seminars, :user_id
  end
end
