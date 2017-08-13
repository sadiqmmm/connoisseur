require "bundler/setup"

require "active_support"
require "active_support/test_case"
require "active_support/testing/autorun"

require "webmock/minitest"

require "connoisseur"

Connoisseur.api_key = "secret"
Connoisseur.user_agent = "Connoisseur Tests"

class ActiveSupport::TestCase
  setup do
    stub_request :any, /.*/
  end
end
