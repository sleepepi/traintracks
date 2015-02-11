# Use to configure basic appearance of template
Contour.setup do |config|

  # Enter your application name here. The name will be displayed in the title of all pages, ex: AppName - PageTitle
  config.application_name = ENV['website_name']

  # If you want to style your name using html you can do so here, ex: <b>App</b>Name
  # config.application_name_html = ''

  # Enter your application version here. Do not include a trailing backslash. Recommend using a predefined constant
  config.application_version = TrainingGrant::VERSION::STRING

  # Enter your application header background image here.
  config.header_background_image = ''

  # Enter your application header title image here.
  # config.header_title_image = ''

  # Enter the items you wish to see in the menu
  config.menu_items =
  [
    {
      name: 'Login', display: 'not_signed_in', path: 'new_user_session_path', position: 'right'
    },
    {
      name: 'image_tag(current_user.avatar_url(18, "blank"))+" "+current_user.name', eval: true, display: 'signed_in', position: 'right', path: 'authentications_path', condition: 'user_signed_in?',
      links: [{ name: "About #{ENV['website_name']} v#{TrainingGrant::VERSION::STRING}", path: 'about_path' },
              { divider: true },
              { header: 'Administrative', condition: 'current_user.system_admin?' },
              { name: 'Users', path: 'users_path', condition: 'current_user.system_admin?' },
              { divider: true, condition: 'current_user.system_admin?' },
              { header: 'current_user.email', eval: true },
              { name: 'Authentications', path: 'authentications_path', condition: 'not PROVIDERS.blank?' },
              { divider: true },
              { name: 'Logout', path: 'destroy_user_session_path' }]
    },
    {
      name: 'image_tag(current_applicant.avatar_url(18, "blank"))+" "+current_applicant.name', eval: true, display: 'signed_in', position: 'right', path: 'root_path', condition: 'applicant_signed_in?',
      links: [{ name: "About #{ENV['website_name']} v#{TrainingGrant::VERSION::STRING}", path: 'about_path' },
              { divider: true },
              { header: 'current_applicant.email', eval: true },
              { divider: true },
              { name: 'Logout', path: 'destroy_applicant_session_path' }]
    },
    {
      name: 'image_tag(current_preceptor.avatar_url(18, "blank"))+" "+current_preceptor.name', eval: true, display: 'signed_in', position: 'right', path: 'root_path', condition: 'preceptor_signed_in?',
      links: [{ name: "About #{ENV['website_name']} v#{TrainingGrant::VERSION::STRING}", path: 'about_path' },
              { divider: true },
              { header: 'current_preceptor.email', eval: true },
              { divider: true },
              { name: 'Logout', path: 'destroy_preceptor_session_path' }]
    },
    {
      name: 'Applicants and Trainees', display: 'signed_in', path: 'applicants_path', position: 'left', condition: 'user_signed_in? and current_user.administrator?',
      links: [{ name: 'Create', path: 'new_applicant_path' }]
    },
    {
      name: 'Annual Information', display: 'signed_in', path: 'annuals_path', position: 'left', condition: 'user_signed_in? and current_user.administrator?'
    },
    {
      name: 'Preceptors', display: 'signed_in', path: 'preceptors_path', position: 'left', condition: 'user_signed_in? and current_user.administrator?',
      links: [{ name: 'Create', path: 'new_preceptor_path' }]
    },
    {
      name: 'Seminars', display: 'signed_in', path: 'seminars_path', position: 'left', condition: 'user_signed_in? and current_user.administrator?',
      links: [{ name: 'Create', path: 'new_seminar_path' },
              { name: 'Attendance', path: 'attendance_seminars_path(status: "current")' }]
    }
  ]

  # Enter an address of a valid RSS Feed if you would like to see news on the sign in page.
  # config.news_feed = ''

  # Enter the max number of items you want to see in the news feed.
  # config.news_feed_items = 3

  # The following three parameters can be set as strings, which will rotate through the colors on a daily basis, selecting an index using (YearDay % ArraySize)

  # A string or array of strings that represent a CSS color code for generic link color
  # config.link_color = nil

  # A string or array of strings that represent a CSS color code for the body background color
  # config.body_background_color = nil

  # A string or array of strings that represent an image url for the body background image
  # config.body_background_image = nil

  # A hash where the key is a string in "month-day" format where values are a hash of the link_color, body_background_color and/or body_background_image
  # An example might be (April 1st), { "4-1" => { body_background_image: 'aprilfools.jpg' } }
  # Note the lack of leading zeros!
  # Special days take precendence over the rotating options given above
  # config.month_day = {}

  # An array of hashes that specify additional fields to add to the sign up form
  # An example might be [ { attribute: 'first_name', type: 'text_field' }, { attribute: 'last_name', type: 'text_field' } ]
  config.sign_up_fields = [ { attribute: 'first_name', type: 'text_field' }, { attribute: 'last_name', type: 'text_field' } ]

  # An array of text fields used to trick spam bots using the honeypot approach. These text fields will not be displayed to the user.
  # An example might be [ :url, :address, :contact, :comment ]
  config.spam_fields = [ :url, :address, :contact, :comment ]
end
