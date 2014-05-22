ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  require 'capybara/rails'

  # Add more helper methods to be used by all tests here...
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end

Capybara.match = :first

def user_signin
    Capybara.current_driver = Capybara.javascript_driver
    assert page.has_content?("Sign in")
    fill_in 'session_email', with: 'bob@bob.com'
    fill_in 'session_password', with: 'testbob'
    click_button('Sign in')
end


class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection