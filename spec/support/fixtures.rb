module FixturesHelper
  def fixture(filename)
    File.join('spec/fixtures', filename)
  end
end