$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'valigator/csv'

require 'support/fixtures'

RSpec.configure do |c|
  c.include FixturesHelper
end