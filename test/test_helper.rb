ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

module DeviseJwtTestHelper
  def generate_jwt_for(user)
    Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
  end
end

module ActiveSupport
  class TestCase
    include DeviseJwtTestHelper
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    #
  end
end
