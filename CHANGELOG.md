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