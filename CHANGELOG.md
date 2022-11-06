## 21.0.0
- **Gem Changes**
  - Update to ruby 3.1.2
  - Update to rails 6.1.4.4
  - Update to mysql 0.5.3
  - Update to carrierwave 2.2.1
  - Update to devise 4.8.0
  - Update to figaro 1.2.0
  - Update to font-awesome-sass 5.12.0
  - Update to haml 5.2.1
  - Update to kaminari 1.2.1

## 20.0.0 (February 21, 2019)

### Enhancements
- **General Changes**
  - Improved display of applicants index
- **Email Changes**
  - Update email subject lines to include Train Tracks
- **Gem Changes**
  - Update to ruby 2.6.1
  - Update to rails 6.0.0.beta1
  - Update to bootstrap 4.3.1
  - Update to carrierwave 1.3.1
  - Update to devise 4.6.1
  - Update to font-awesome-sass 5.6.1

## 19.0.1 (December 14, 2018)

### Enhancements
- **Gem Changes**
  - Update to rails 5.2.2
  - Update to font-awesome-sass 5.5.0

### Bug Fix
- Fix bug that prevented applicants from registering

## 19.0.0 (October 22, 2018)

### Enhancements
- **General Changes**
  - Add updated Privacy Policy
  - Updated interface for applicants, preceptors, and admins
- **Gem Changes**
  - Update to rails 5.2.1
  - Update to mysql2 0.5.2
  - Update to bootstrap 4.1.3
  - Update to carrierwave 1.2.3
  - Update to devise 4.5.0
  - Update to font-awesome-sass 5.4.1
  - Update to jquery-rails 4.3.3

## 18.0.0 (April 17, 2018)

### Enhancements
- **Gem Changes**
  - Updated to ruby 2.5.1
  - Updated to rails 5.2.0
  - Updated to mysql2 0.5.1
  - Updated to carrierwave 1.2.2
  - Updated to devise 4.4.3
  - Updated to haml 5.0.4
  - Updated to kaminari 1.1.1
  - Updated to simplecov 0.16.1

## 0.17.0 (May 16, 2017)

### Enhancements
- **General Changes**
  - Login cookies are now cross subdomain and work between www and non-www URLs
  - Rails `belongs_to` relationship is now required by default
  - Improved loading of annuals index page
- **Gem Changes**
  - Updated to Ruby 2.4.1
  - Updated to rails 5.1.1
  - Updated to devise 4.3.0
  - Updated to carrierwave 1.1.0
  - Updated to haml 5.0.1
  - Updated to kaminari 1.0.1
  - Updated to jquery-rails 4.3.1
  - Updated to mysql2 0.4.6
  - Updated to simplecov 0.14.1

### Bug Fixes
- Fixed a bug that caused JavaScript functions to run twice in browsers that
  supported Turbolinks

## 0.16.0 (January 5, 2017)

### Enhancements
- **General Changes**
  - Reduced number of alerts and messages from devise during login and logout
- **Gem Changes**
  - Updated to Ruby 2.4.0
  - Updated to rails 5.0.1
  - Updated to jquery-rails 4.2.2
  - Updated to carrierwave 1.0.0
  - Updated to mysql2 0.4.5

## 0.15.0 (September 28, 2016)

### Enhancements
- **Annual Changes**
  - Training grant administrators now receive an email when trainees update
    their annual profile information
- **Email Changes**
  - Annual update reminder emails are now sent in background
- **Gem Changes**
  - Updated to jquery-rails 4.2.1

## 0.14.2 (August 19, 2016)

### Bug Fix
- Fixed a bug that prevented typeahead fields from displaying correctly

## 0.14.1 (August 19, 2016)

### Bug Fixes
- Fixed a bug that prevented seminars without presentation dates from displaying
  properly
- Fixed a bug that prevented forms from being submitted due to CSRF origin check

## 0.14.0 (August 18, 2016)

### Enhancements
- **Annual Changes**
  - Trainees updating their annual information can now save the updated
    information as a draft
- **Gem Changes**
  - Updated to rails 5.0.0.1
  - Updated to coffee-rails 4.2
  - Updated to jbuilder 2.5
  - Updated to jquery-rails 4.1.1

## 0.13.0 (August 16, 2016)

### Enhancements
- **General Changes**
  - Created new database table to track applicant degrees
- **Gem Changes**
  - Updated to Ruby 2.3.1
  - Updated to devise 4.2.0
  - Updated to turbolinks 5
  - Updated to carrierwave 0.11.2
  - Updated to kaminari 0.17.0
  - Updated to simplecov 0.12.0
  - Updated to mysql2 0.4.4
  - Removed dependency on contour
  - Removed dependency on ruby-ntlm-namespace

## 0.12.5 (March 2, 2016)

### Enhancements
- **Email Changes**
  - Updated styling consistency across emails

### Bug Fix
- Fixed URLs for password reset, password confirmation, and email confirmation
  emails

## 0.12.4 (March 1, 2016)

### Enhancements
- **General Changes**
  - Improvements to how emails are generated and sent
- **Gem Changes**
  - Updated to rails 4.2.5.2
  - Updated to mysql2 0.4.3

### Refactoring
- Updated files based on RuboCop recommendations

## 0.12.3 (January 26, 2016)

### Enhancements
- **Gem Changes**
  - Updated to rails 4.2.5.1
  - Updated to jquery-rails 4.1.0

## 0.12.2 (January 12, 2016)

### Enhancements
- **Applicant Changes**
  - Trainee yearly reporting now covers 15 years
- **Gem Changes**
  - Updated to Ruby 2.3.0
  - Updated to rails 4.2.5
  - Updated to mysql2 0.4.2
  - Updated to simplecov 0.11.1
  - Updated to web-console 3.0
  - Removed minitest-reporters

### Bug Fix
- Fixed a bug that prevented users with tokens ending in hyphens from authenticating correctly

## 0.12.1 (August 6, 2015)

### Enhancements
- **Preceptor Changes**
  - Added publications and grants fields to preceptors
- **General Changes**
  - Added turbolinks progress bar
  - Added a version page
- **Gem Changes**
  - Updated to rails 4.2.3
  - Updated to contour 3.0.1
  - Updated to mysql2 0.3.19
  - Added web-console for development

## 0.12.0 (June 9, 2015)

### Enhancements
- **Seminar Changes**
  - Seminars outside a trainee's training period start date and training period end date no longer count against the trainee's attendance percentage
  - Future seminars no longer count against a trainee's attendance percentage
- **General Changes**
  - Updated about page links to new GitHub repository location
- **Gem Changes**
  - Updated to contour 3.0.0.rc
  - Updated to figaro 1.1.1

## 0.11.1 (May 22, 2015)

### Enhancements
- Use of Ruby 2.2.2 is now recommended
- **Gem Changes**
  - Updated to simplecov 0.10.0

## 0.11.0 (March 26, 2015)

### Enhancements
- **General Changes**
  - Streamlined login system by removing alternate logins
  - Improved registration, login, password reset, and other pages for admins, trainees, and preceptors
    - Added user role icons from http://www.aha-soft.com/free-icons/free-large-boss-icon-set/
  - Added a contact page
- **Applicant Changes**
  - The Progress Report Data Section is now available for applicants and trainees to fill out
    - Approved IRB Protocols (multi-line string)
    - IRB Approval and Protocols Document (PDF or DOC)
    - Approved IACUC Protocols (multi-line string)
    - IACUC Protocols Document (PDF or DOC)
- Use of Ruby 2.2.1 is now recommended
- **Gem Changes**
  - Updated to rails 4.2.1
  - Updated to mysql2 0.3.18
  - Updated to contour 3.0.0.beta1
  - Use Haml for new views

### Bug Fix
- Reduced the amount of information logged to the log file

## 0.10.9 (February 12, 2015)

### Enhancements
- Use of Ruby 2.2.0 is now recommended
- **Gem Changes**
  - Updated to rails 4.2.0
  - Updated to contour 2.7.0.beta1
  - Updated to kaminari 0.16.3
  - Use Figaro to centralize application configuration

## 0.10.8 (December 12, 2014)

### Enhancements
- **Gem Changes**
  - Updated to rails 4.2.0.rc2

## 0.10.7 (November 25, 2014)

### Enhancements
- Use of Ruby 2.1.5 is now recommended
- Updated Google Omniauth to no longer write to disk
- **Gem Changes**
  - Updated to rails 4.2.0.beta4
  - Updated to contour 2.6.0.beta8
  - Updated to mysql 0.3.17

## 0.10.6 (August 18, 2014)

### Enhancements
- **Applicant Changes**
  - Added eRA Commons Username as an editable field for administrators
- **Gem Changes**
  - Updated to rails 4.1.4
  - Updated to kaminari 0.16.1
  - Updated to simplecov 0.9.0

## 0.10.5 (May 30, 2014)

### Bug Fix
- Fixed an issue that caused seminars without dates from being displayed properly

## 0.10.4 (May 30, 2014)

### Enhancements
- **General Changes**
  - Updated email styling template
- Use of Ruby 2.1.2 is now recommended
- **Gem Changes**
  - Updated to rails 4.1.1
  - Updated to mysql2 0.3.16
  - Updated to contour 2.5.0
  - Updated to carrierwave 0.10.0
  - Removed turn, and replaced with minitest and minitest-reporters

## 0.10.3 (February 26, 2014)

### Enhancements
- Admins now have better control over sending login links to applicants and preceptors
- **Gem Changes**
  - Updated to rails 4.0.3
  - Updated to contour 2.4.0.beta3

## 0.10.2 (February 18, 2014)

### Bug Fix
- Entering annual information for `Source of Support` longer than 255 now provides a friendly warning instead of a failure to load page as well as providing a hint to keep the information short
- Added checks to assure active record would provide a warning before sending strings longer than 255 to PostgreSQL

## 0.10.1 (February 11, 2014)

### Enhancements
- **Annuals Changes**
  - NIH Other Support document is no longer required when applicants fill out an annual review

## 0.10.0 (February 11, 2014)

### Enhancements
- **Applicants Changes**
  - Added additional program requirements section for admins to enter
  - Additional Program Requirements can be downloaded as a CSV
  - Admin Only section now includes 'Curriculum Advisor', 'Most Recent Curriculum Advisor Meeting Date', and 'Past Curriculum Advisor Meetings'

### Bug Fix
- Annual reminder email is now filtered to trainees who have been supported by the training grant

## 0.9.1 (February 3, 2014)

### Enhancements
- Removed deprecated applicant fields, `degrees_earned_old`, `concentration_major`, `advisor`, `thesis`, `degree_types`.

### Bug Fix
- Sending an annual reminder now works correctly when sending reminer to a single applicant from the applicant page
- Applicants who are not enrolled or reviewed are no longer given a default status of "current" when modified by an administrator

## 0.9.0 (January 31, 2014)

### Enhancements
- Faster page navigation through the use of turbolinks
- Applicants and Trainees page now sortable by training period start date
- Annuals now include Degree or Certifications earned (Year) or Other Relevant Outcome
- Annual Reminder emails are now sent to former trainees who had a training grant end date in the last 10 years
- **Gem Changes**
  - Updated to mysql2 0.3.15

### Bug Fix
- The remove degree row button now properly removes the corresponding row

## 0.8.5 (January 8, 2014)

### Enhancements
- Use of Ruby 2.1.0 is now recommended
- **Gem Changes**
  - Updated to jbuilder 2.0
  - Updated to contour 2.2.1

## 0.8.4 (December 5, 2013)

### Enhancements
- Use of Ruby 2.0.0-p353 is now recommended
- Bootstrap 3 styling changes for user form

## 0.8.3 (December 4, 2013)

### Enhancements
- **Gem Changes**
  - Updated to rails 4.0.2
  - Updated to contour 2.2.0.rc2
  - Updated to kaminari 0.15.0
  - Updated to coffee-rails 4.0.1
  - Updated to sass-rails 4.0.1
  - Updated to simplecov 0.8.2
  - Updated to mysql 0.3.14
- Removed support for Ruby 1.9.3

## 0.8.2 (September 3, 2013)

### Enhancements
- **General Changes**
  - The interface now uses [Bootstrap 3](http://getbootstrap.com/)
  - Gravatars added for users
  - Reorganized Menu
- **Gem Changes**
  - Updated to contour 2.1.0.rc

## 0.8.1 (August 13, 2013)

### Bug Fix
- Fixed a parameter slicing bug that prevented new applicants from registering successfully

## 0.8.0 (August 1, 2013)

### Enhancements
- **Applicant Changes**
  - Preceptors are now listed alphabetically by last name in dropdowns
- **Preceptor Changes**
  - Added example to degree field
  - Added example `Other-Support.doc` to Other Support field
  - Rank is now only editable by administrator and changed to dropdown with choices `Associate Preceptor` and `Full Preceptor`
  - Added Biosketch and Curriculum Vitae to preceptor file uploads
  - Configurable hospital list added to Hospital Affilation field
- Added calendar icons to date input fields
- **Gem Changes**
  - Updated to contour 2.0.0
  - Updated to mysql2 0.3.13
  - Updated to carrierwave 0.9.0

## 0.7.2 (July 9, 2013)

### Enhancements
- Use of Ruby 2.0.0-p247 is now recommended
- **Gem Changes**
  - Updated to rails 4.0.0

## 0.7.1 (June 7, 2013)

### Enhancements
- Use of Ruby 2.0.0-p195 is now recommended
- **Gem Changes**
  - Updated to rails 4.0.0.rc1
  - Updated to contour 2.0.0.beta.8

## 0.7.0 (April 12, 2013)

### Enhancements
- **Attendance Changes**
  - Seminar attendance table now shows the percentage of lectures attended by category for each trainee
- **Gem Changes**
  - Updated to Rails 4.0.0.beta1
  - Updated to Contour 2.0.0.beta.4

## 0.6.5 (March 26, 2013)

### Bug Fix
- Fixed a bug that prevented filtering in the attendance module

## 0.6.4 (March 20, 2013)

### Enhancements
- Use of Ruby 2.0.0-p0 is now recommended

## 0.6.3 (February 15, 2013)

### Security Fix
- Updated Rails to 3.2.12

### Enhancements
- Seminar Attendance now filters seminars by school year, July 1st -> June 30th
- Simplified applicants index
- Presentations in exports now labeled as, "Conferences, Presentations, Honors, and Fellowships"
- ActionMailer can now also be configured to send email through NTLM
  - `ActionMailer::Base.smtp_settings` now requires an `:email` field
- Contour updated to 1.2.0.pre8

## 0.6.2 (January 22, 2013)

### Bug Fix
- Administrators should be able to update applicants that do not have an email address

## 0.6.1 (January 14, 2013)

### Bug Fix
- Fixed a bug that caused all enrolled trainees to be notified of seminars instead of just current trainees

## 0.6.0 (January 11, 2013)

### Enhancements
- Seminar attendance can now be tracked for enrolled trainees
- Updated to Contour 1.1.2 and use Contour pagination theme
- Seminar Reminder email added for current trainees

## 0.5.5 (January 8, 2013)

### Security Fix
- Updated Rails to 3.2.11

## 0.5.4 (January 3, 2013)

### Security Fix
- Updated Rails to 3.2.10

### Bug Fix
- User activation emails are no longer sent out when a user's status is changed from `pending` to `inactive`

## 0.5.3 (November 28, 2012)

### Enhancements
- Gem updates including Rails 3.2.9 and Ruby 1.9.3-p327
- Contour updated to 1.1.1

## 0.5.2 (October 25, 2012)

### Enhancements
- Restructured login page to give clearer distinctions between all of the login types
- Added `Unknown` citizenship status category
- Preceptors are now notified that they need to confirm emails after editing their existing email address

### Bug Fix
- Removed TableScroll that was causing the column headers to not properly line up in some browsers
- Fixed the link to the RSS feed

## 0.5.1 (September 17, 2012)

### Enhancements
- Preceptor Other Support document now a file (`docx`, `doc`, `pdf`) upload
- Administrators can export selected preceptor information to a CSV file
- Preceptor page lists applicants who have the preceptor set as their primary or secondary preceptor
- Deleting preceptors or applicants sets the email field to blank so that the email can be potentially reused
- Applicant help buttons on applicant pages that create help request emails for the Training Grant Administrator

### Refactoring
- Unused `cv` variable has been removed, (previously replaced by `curriculum_vitae`)

## 0.5.0 (August 28, 2012)

### Enhancements
- **Applicant Changes**
  - Multiple degrees can be added to applicants
    - Degree Type, Institution, Year, Advisor, Thesis, and Concentration / Major
  - Previous Institutions has been merged with Degrees Earned
  - Citizenship status is simplified
  - Research Interests are now required
- **Administrator Changes**
  - Notify applicants and trainees to fill out annual information
  - Modify submission date on applicant page
  - View different time ranges for reports on dashboard
  - Export selected applicant information to a CSV file
  - Export annual information to CSV
  - Notify enrolled trainees to complete exit interviews
- **Preceptor Changes**
  - Preferred preceptors are notified by email applicants submit their applications

## 0.4.2 (August 14, 2012)

### Enhancements
- Updated to Rails 3.2.8
  - Removed deprecated use of update_attribute for Rails 4.0 compatibility
- **Email Changes**
  - Default application name is now added to the from: field for emails
  - Email subjects no longer include the application name
- About page reformatted to include links to github and contact information

### Refactoring
- Consistent sorting and display of model counts used across all objects, (applicants, preceptors, users)

### Testing
- Use ActionDispatch for Integration tests instead of ActionController

### Bug Fix
- Applicant sign up page now displays correctly

## 0.4.1 (July 10, 2012)

### Bug Fix
- Failure to send emails in production no longer generate error messages

## 0.4.0 (June 14, 2012)

### Enhancements
- **Applicant Changes**
  - Degrees Earned now combines Degree, Institution, and Year of Graduation
    - Previous Institutions will be removed
  - Citizenship Status added with required alien registration number for permanent residents
  - Degree types can be specified using checkboxes
  - Names of professors writing letters of recommendations required
  - Gender has been added
  - Degree sought is now a radio button option
  - URM Types can now be specified on application
- Update to Rails 3.2.6 and Contour 1.0.1
- Updated Devise configuration files for devise 2.1.0

### Bug Fix
- Administrators can now update applicant emails without going through the email confirmation/reconfirmation process

## 0.3.1 (May 11, 2012)

### Bug Fix
- Initial setup now runs correctly: `require 'securerandom'`

## 0.3.0 (May 11, 2012)

### Enhancements
- **Applicant Changes**
  - can fall into either `predoc`, `postdoc`, or `summer` categories
  - can have a "personal statement" to fill out
  - added requirement to mail or email 3 recommendation letters
  - need to confirm their emails before being able to sign in
  - can upload a curriculum vitae
  - can have three preferred preceptors
- Applications now have required fields that need to be completed before submission, however these are not required to save as a draft
- Application type now affects what fields are displayed to the applicant
- Administrators can now allow an applicant to resubmit their application
- Use new Contour login attributes on Registration page
- Use Contour for User account Confirmations and Unlocks

## 0.2.0 (May 3, 2012)

### Enhancements
- Dashboard with quick applicant statistics added
- Applicant page restructured
  - General Information
  - Contact Information
  - Education Information
  - Predoc and Postdoc section (general)
  - Trainee section
  - Administrative section
- **Applicants**
  - List of applicants now utilizes a frozen header row
  - Added marital status
  - Add submitted at timestamp
  - Applicant Number renamed to CV Number
  - Reference number is now generated for each application
- Login and Registration
  - Adminstrator Role added for management of applicants and preceptors
  - Applicants can now register and login to create an application
  - Preceptors can now login to edit their information
- **Administrators**
  - Can send emails to applicants and preceptors to notify them to update their information
- Using Contour 1.0.0 with Twitter-Bootstrap

## 0.1.0 (April 16, 2012)

### Enhancements
- Preceptors can now be managed
- Applicants (Predoc and Postdoc) and Trainees can now be managed

## 0.0.0 (April 2, 2012)

- Skeleton files to initialize Rails application with testing framework and continuous integration
