require 'spec_helper'

  describe 'CSV' do
    it 'has a version number' do
      expect(Valigator::CSV::VERSION).not_to be nil
    end
  end
