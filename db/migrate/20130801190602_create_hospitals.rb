class CreateHospitals < ActiveRecord::Migration
  def change
    create_table :hospitals do |t|
      t.string :name
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
  end
end
