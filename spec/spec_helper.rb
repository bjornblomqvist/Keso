$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'keso'
require 'rspec'

RSpec.configure do |config|
  config.mock_with :rspec
end
