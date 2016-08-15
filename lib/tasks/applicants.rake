# frozen_string_literal: true

# TODO: Remove in 0.14.0
namespace :applicants do
  desc 'Migrate applicant degrees to new database table.'
  task migrate_degrees: :environment do
    ActiveRecord::Base.connection.execute('TRUNCATE degrees')
    Applicant.find_each do |applicant|
      applicant.degrees_earned.each_with_index do |hash, index|
        applicant.degrees.create(
          position: index,
          degree_type: (Degree::DEGREE_TYPES.collect(&:second).include?(hash[:degree_type]) ? hash[:degree_type] : ''),
          institution: hash[:institution],
          year: hash[:year],
          advisor: hash[:advisor],
          thesis: hash[:thesis],
          concentration_major: hash[:concentration_major]
        )
      end
    end
  end
end
# END TODO
