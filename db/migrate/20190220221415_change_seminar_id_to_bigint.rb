class ChangeSeminarIdToBigint < ActiveRecord::Migration[6.0]
  def up
    change_column :seminars, :id, :bigint, auto_increment: true

    change_column :applicants_seminars, :seminar_id, :bigint
  end

  def down
    change_column :seminars, :id, :integer, auto_increment: true

    change_column :applicants_seminars, :seminar_id, :integer
  end
end
