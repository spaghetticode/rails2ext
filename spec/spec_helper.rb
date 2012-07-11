require 'mocha'
require 'rails2ext'

MOCHA_OPTIONS = 'skip_integration'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end
