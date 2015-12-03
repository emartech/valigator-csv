require 'spec_helper'

module Valigator
  module CSV
    describe Validator do
      describe '#validate' do
        it 'should collect no errors for valid files' do
          subject = described_class.new fixture('valid.csv')
          subject.validate

          expect(subject.errors).to eq []
        end


        it 'should use the provided dialect to parse the CSV' do
          subject = described_class.new fixture('valid_custom.csv')
          subject.validate col_sep: ";", quote_char: "'"

          expect(subject.errors).to eq([])
        end


        it 'should detect invalid byte sequence when opening with default encoding' do
          subject = described_class.new fixture('invalid_encoding.csv')
          subject.validate

          expect(subject.errors).to eq([Error.new(row: nil, type: 'invalid_encoding', message: 'invalid byte sequence in UTF-8')])
        end


        it 'should not report byte sequence error when opened with the correct encoding' do
          subject = described_class.new fixture('invalid_encoding.csv')
          subject.validate(encoding: 'ISO-8859-9')

          expect(subject.errors).to eq([])
        end


        it 'should detect quoting problems' do
          subject = described_class.new fixture('unclosed_quote.csv')
          subject.validate

          expect(subject.errors).to eq [Error.new(row: 4, type: 'unclosed_quote', message: 'Unclosed quoted field on line 4.')]
        end


        it 'should (re)raise error, if it is not directly parsing related' do
          subject = described_class.new fixture('unclosed_quote.csv')

          expect { subject.validate quote_char: 'asd'}.to raise_error ArgumentError, ':quote_char has to be a single character String'
        end

      end
    end

  end
end