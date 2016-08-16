class CreateApplicants < ActiveRecord::Migration[4.2]
  def change
    create_table :applicants do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_initial
      t.string :applicant_type
      t.boolean :accepted, null: false, default: false
      t.string :advisor
      t.integer :applicant_number
      t.string :concentration_major
      t.string :current_institution
      t.boolean :cv, null: false, default: false
      t.string :degree_sought
      t.string :department_program
      t.boolean :disabled
      t.boolean :disadvantaged
      t.boolean :enrolled, null: false, default: false
      t.integer :expected_year
      t.boolean :offered, null: false, default: false
      t.integer :preferred_preceptor_id
      t.integer :primary_preceptor_id
      t.integer :secondary_preceptor_id
      t.text :previous_institutions
      t.date :review_date
      t.boolean :reviewed, null: false, default: false
      t.boolean :summer, null: false, default: false
      t.boolean :tge
      t.string :thesis
      t.boolean :urm
      t.integer :year
      t.string :degree_type
      t.string :degrees
      t.text :notes
      t.string :residency
      t.string :year_department_program
      t.date :training_period_start_date
      t.date :training_period_end_date
      t.string :email
      t.string :appointment_type
      t.string :status
      t.string :current_position_or_source_of_support
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :country
      t.string :zip_code
      t.text :coursework_comp
      t.string :fax
      t.string :grant_years
      t.string :phone
      t.text :presentations
      t.string :pubs_not_prev_rep
      t.text :research_description
      t.string :source_of_support
      t.boolean :supported_by_tg, null: false, default: false
      t.string :tg_years
      t.string :research_project_title
      t.string :trainee_code
      t.boolean :deleted, default: false, null: false

      t.timestamps
    end
  end
end
