$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'valigator/csv'
require 'support/fixtures'

RSpec.configure do |c|
  c.include FixturesHelper

  c.filter_run_excluding ruby: ->(version_requirement) do
    not Gem::Requirement.create(version_requirement).satisfied_by?(Gem::Version.create(RUBY_VERSION))
  end
end
