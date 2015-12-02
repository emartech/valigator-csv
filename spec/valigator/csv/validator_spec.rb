require 'spec_helper'


describe Valigator::CSV::Validator do
  describe '#validate' do
    it 'should collect no errors for valid files' do
      subject = described_class.new fixture('valid.csv')
      subject.validate

      expect(subject.errors).to eq []
    end


    it 'should detect quoting problems' do
      subject = described_class.new fixture('unclosed_quote.csv')
      subject.validate

      expect(subject.errors.first).to eq Valigator::CSV::Error.new(row: 4, type: 'unclosed_quote', message: "Unclosed quoted field on line 4.")
    end
  end
end
