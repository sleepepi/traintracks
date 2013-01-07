class CreateApplicantsSeminars < ActiveRecord::Migration
  def change
    create_table :applicants_seminars, id: false do |t|
      t.integer :seminar_id
      t.integer :applicant_id
    end

    add_index :applicants_seminars, :seminar_id
    add_index :applicants_seminars, :applicant_id
  end
end
