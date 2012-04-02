class CreatePreceptors < ActiveRecord::Migration
  def change
    create_table :preceptors do |t|
      t.string :first_name
      t.string :last_name
      t.string :degree
      t.string :status, default: 'current', null: false
      t.string :hospital_affiliation
      t.string :hospital_appointment
      t.boolean :other_support, default: false, null: false
      t.string :rank
      t.text :research_interest
      t.string :program_role
      t.boolean :deleted, default: false, null: false

      t.timestamps
    end
  end
end
