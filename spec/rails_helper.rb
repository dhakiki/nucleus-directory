# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'selenium-webdriver'
require 'capybara/rspec'
require 'factory_girl_rails'

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!
DatabaseCleaner.strategy = :truncation

Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile.native_events = true
  profile["focusmanager.testmode"] = true
  Capybara::Selenium::Driver.new app, browser: :firefox, profile: profile
end


RSpec.configure do |config|

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  config.include FactoryGirl::Syntax::Methods
  config.before(:each, selenium: true) do
    Capybara.current_driver = :selenium
  end

  config.after(:each, selenium: true) do
    Capybara.current_driver = Capybara.default_driver
  end
  

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
  config.include Capybara::DSL
  config.before(:suite) do
    DatabaseCleaner.clean
    #todo: figure out why create didn't work on feature tests and must be called here
    FactoryGirl.create :user
    FactoryGirl.create(:user, first_name: 'Keanu', last_name: 'Reeves', full_name: 'Keanu Reeves', email: 'keanu.reeves@originate.com')
    FactoryGirl.create(:user, first_name: 'Tobe', last_name: 'Deleted', full_name: 'Tobo Deleted', email: 'tobe.deleted@originate.com')
    FactoryGirl.create(:user, first_name: 'Donald', last_name: 'Trump', full_name: 'Donald Trump', email: 'donald.trump@originate.com')
    FactoryGirl.create(:user, first_name: 'Rob', last_name: 'Meadows', full_name: 'Rob Meadows', email: 'rob.meadows@originate.com')
    FactoryGirl.create(:user, first_name: 'Bob', last_name: 'Meadows', full_name: 'Bob Meadows', email: 'bob.meadows@originate.com')
    FactoryGirl.create(:user, first_name: 'BobTheBuilder', last_name: 'Meadows', full_name: 'BobTheBuilder Meadows', email: 'bobthebuilder.meadows@originate.com')
    FactoryGirl.create(:user, first_name: 'Kevin', last_name: 'Goslar', full_name: 'Kevin Goslar', email: 'kevin.goslar@originate.com')
    FactoryGirl.create(:user, first_name: 'Robert', last_name: 'Meadows', full_name: 'Robert Meadows', email: 'robert.meadows@originate.com')
    FactoryGirl.create(:user, first_name: 'Dora', last_name: 'Explorer', full_name: 'Dora Explorer', email: 'dora.explorer@originate.com', supervisor_id: 8, supervisor_name: 'Kevin Goslar')
    FactoryGirl.create(:user, first_name: 'Boots', last_name: 'Explorer', full_name: 'Boots Explorer', email: 'boots.explorer@originate.com', supervisor_id: 9, supervisor_name: 'Robert Meadows')
    FactoryGirl.create :skill
    FactoryGirl.create(:skill, name: 'Acting', level: 1, user_id: 2)
  end
end
