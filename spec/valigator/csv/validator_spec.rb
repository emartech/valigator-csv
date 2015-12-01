require 'spec_helper'


describe Valigator::CSV::Validator do
  describe '#validate' do
    it 'should collect no errors for valid files' do
      subject = described_class.new fixture('valid.csv')
      subject.validate

      expect(subject.errors).to eq []
    end


    xit 'should detect quoting problems' do
      subject = described_class.new fixture('unclosed_quote.csv')
      subject.validate

      expect(subject.errors.first).to eq([Valigator::CSV::Error.new({row: 4,
                                                                     type: 'unclosed_quote',
                                                                     message: "Unclosed quoted field on line 4."})])
    end


    xit 'should report missing headers' do
      subject = described_class.new fixture('malformed_header.csv')
      subject.validate(headers: [
        {name: 'h1'},
        {name: 'h2'},
        {name: 'h3'}
      ])

      expect(subject.errors).to eq([{row: 1, type: 'malformed_header', content: "h1,h2"}])
    end


    xit 'should report missing values' do
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


    xit 'should report not unique values' do
      subject = described_class.new fixture('not_unique.csv')

      subject.validate headers: [
        {name: 'id', constraints: {unique: true}},
        {name: 'h'}
      ]

      expect(subject.errors).to eq([{row: 4, column: 1, type: "unique", content: "1"}])
    end


    xit 'should use the provided dialect to parse the CSV' do
      subject = described_class.new fixture('valid_custom.csv')

      subject.validate dialect: {delimiter: ";", quotaChar: "'"}

      expect(subject.errors).to eq([])
    end

  end

end
