class CreateDegrees < ActiveRecord::Migration[4.2]
  def change
    create_table :degrees do |t|
      t.integer :applicant_id
      t.integer :position, null: false, default: 0
      t.string :degree_type
      t.string :institution
      t.integer :year
      t.string :advisor
      t.string :thesis
      t.string :concentration_major

      t.timestamps null: false
    end
    add_index :degrees, :applicant_id
    add_index :degrees, :position
  end
end
