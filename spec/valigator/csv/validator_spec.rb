require 'spec_helper'


describe Valigator::CSV::Validator do
  describe '#validate' do
    it 'should collect no errors for valid files' do
      subject = described_class.new fixture('valid.csv')
      subject.validate

      expect(subject.errors).to eq []
    end


    it 'should detect invalid encoding' do
      subject = described_class.new fixture('invalid_encoding.csv')
      subject.validate

      expect(subject.errors).to eq([{line: 3, error: 'invalid_encoding', content: '3'}])
    end


    it 'should detect quoting problems' do
      subject = described_class.new fixture('unclosed_quote.csv')
      subject.validate

      expect(subject.errors).to eq([{line: 4, error: 'unclosed_quote', content: "a1,\"a2\",\"a3\r\nb1,b2,b3\r\nb1,b2,b3\r\nb1,b2,b3\r\nb1,b2,b3\r\nb1,b2,b3\r\nb1,b2,b3\r\nb1,b..."}])
    end
  end
end
