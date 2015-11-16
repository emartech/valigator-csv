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

      expect(subject.errors).to eq([{row: 3, type: 'invalid_encoding', content: '3'}])
    end


    it 'should detect quoting problems' do
      subject = described_class.new fixture('unclosed_quote.csv')
      subject.validate

      expect(subject.errors).to eq([{row: 4, type: 'unclosed_quote', content: "a1,\"a2\",\"a3\r\nb1,b2,b3\r\nb1,b2,b3\r\nb1,b2,b3\r\nb1,b2,b3\r\nb1,b2,b3\r\nb1,b2,b3\r\nb1,b..."}])
    end


    it 'should report missing headers' do
      subject = described_class.new fixture('malformed_header.csv')
      subject.validate(headers: [
        {name: 'h1'},
        {name: 'h2'},
        {name: 'h3'}
      ])

      expect(subject.errors).to eq([{row: 1, type: 'malformed_header', content: "h1,h2"}])
    end


    it 'should report missing values' do
      subject = described_class.new fixture('missing_values.csv')

      subject.validate headers: [
        {name: 'h1', constraints: {required: true}},
        {name: 'h2'},
        {name: 'h3', constraints: {required: true}}
      ]

      expect(subject.errors).to eq([
                                     {row: 2, column: 1, type: 'missing_value'},
                                     {row: 4, column: 3, type: 'missing_value'}
                                   ])
    end
  end

end
