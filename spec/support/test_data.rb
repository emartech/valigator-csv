module TestDataHelper


  def test_data(filename)
    File.join "spec/fixtures", filename
  end

end