ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    # Log in as a particular user.
    def login_admin(user)
      post login_path, params: { email: user.email, password: "admin"  }
    end

    def login_user(user)
      post login_path, params: { email: user.email, password: "password"  }
    end

  end
end
