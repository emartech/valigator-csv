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
          subject.validate(col_sep: ";", quote_char: "'")

          expect(subject.errors).to eq([])
        end


        it "forwards csv header options" do
          subject = described_class.new fixture('valid.csv')
          expect(::CSV).to receive(:foreach).with(fixture('valid.csv'), col_sep: ',', quote_char: '"', encoding: 'UTF-8', headers: true, return_headers: false)

          subject.validate headers: true, return_headers: false
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


        it 'should detect invalid encoding' do
          subject = described_class.new fixture('invalid_encoding2.csv')
          config = {
            :encoding => "BOM|UTF-8",
            :col_sep => "\t",
            :quote_char => "\"",
            :headers => true,
            :fields => ["brandcode", "order", "storecode", "date", "hour", "customer", "superid", "item", "quantity", "unitprice", "c_sales_amount", "postdate"],
            :field_validators => {
              "quantity" => Valigator::CSV::FieldValidators::Float.new({:decimal_mark => nil, :allow_blank => false})
            }
          }
          subject.validate(config)

          expect(subject.errors).to eq([Error.new(row: nil, type: 'invalid_encoding', message: 'ASCII incompatible encoding: UTF-16LE')])
        end


        it 'should detect quoting problems' do
          subject = described_class.new fixture('unclosed_quote.csv')
          subject.validate

          expect(subject.errors).to eq [Error.new(row: 4, type: 'unclosed_quote', message: 'Unclosed quoted field on line 4.')]
        end


        it 'detects stray quote' do
          subject = described_class.new fixture('stray_quote.csv')
          subject.validate

          expect(subject.errors).to eq [Error.new(row: 2, type: 'stray_quote', message: 'Missing or stray quote in line 2')]
        end


        it 'detects inconsistent line breaks' do
          subject = described_class.new fixture('inconsistent_line_breaks.csv')
          subject.validate

          expect(subject.errors).to eq [Error.new(row: 2, type: 'line_breaks', message: 'Unquoted fields do not allow \\r or \\n (line 2).')]
        end


        it 'should (re)raise error, if it is not directly parsing related' do
          subject = described_class.new fixture('unclosed_quote.csv')

          expect { subject.validate quote_char: 'asd' }.to raise_error ArgumentError, ':quote_char has to be a single character String'
        end


        context 'mandatory field' do
          subject { described_class.new fixture('missing_mandatory_field.csv') }

          it 'does not validate unless fields given' do
            options = {
              field_validators: {
                "id" => Valigator::CSV::FieldValidators::Mandatory.new
              }
            }

            subject.validate(options)
            expect(subject.errors).to eq []
          end

          it 'does not validate unless field validators given' do
            options = {
              fields: %w(id name)
            }

            subject.validate(options)
            expect(subject.errors).to eq []
          end

          it 'reports field with nil value' do
            options = {
              fields: %w(id name),
              field_validators: {
                "id" => Valigator::CSV::FieldValidators::Mandatory.new
              }
            }

            subject.validate(options)

            expect(subject.errors).to eq [Error.new(type: 'missing_field', message: 'Missing mandatory field', row: 4, field: 'id')]
          end
        end


        context 'ragged rows' do
          subject { described_class.new fixture('ragged_rows.csv') }


          it 'does not validate number of fields if there is no fields options defined' do
            subject.validate()
            expect(subject.errors).to eq []
          end


          it 'reports rows with different number of fields than the options' do
            options = {
              fields: %w(id name),
              row_validators: [Valigator::CSV::RowValidators::Ragged]
            }

            subject.validate(options)

            expect(subject.errors).to eq [Error.new(type: 'ragged_row', message: 'Ragged or empty row', row: 3)]
          end


        end


        context 'abort validation' do
          subject { described_class.new fixture('too_many_errors.csv') }

          let(:config) do
            {
              headers: true,
              fields: %w(order date customer item c_sales_amount quantity unit_price),
              field_validators: {
                "order" => Valigator::CSV::FieldValidators::Date.new(format: '%Y%m%d'),
                "date" => Valigator::CSV::FieldValidators::Date.new(format: '%Y%m%d'),
                "customer" => Valigator::CSV::FieldValidators::Date.new(format: '%Y%m%d'),
                "ite±m" => Valigator::CSV::FieldValidators::Date.new(format: '%Y%m%d'),
                "c_sales_amount" => Valigator::CSV::FieldValidators::Date.new(format: '%Y%m%d'),
                "quantity" => Valigator::CSV::FieldValidators::Date.new(format: '%Y%m%d'),
                "unit_price" => Valigator::CSV::FieldValidators::Date.new(format: '%Y%m%d')
              }
            }
          end


          it 'aborts when reaching default value' do
            subject.validate(config)

            expect(subject.errors.size).to eq(1000 + 3)
            expect(subject.errors.last).to eq(Error.new(type: 'too_many_errors', message: 'Too many errors were found'))
          end


          it 'aborts when reaching value given as option' do
            subject.validate(config.merge(errors_limit: 1))

            expect(subject.errors.size).to eq(1 + 6)
            expect(subject.errors.last).to eq(Error.new(type: 'too_many_errors', message: 'Too many errors were found'))
          end


          it 'setting the limit to nil disables the limit' do
            subject.validate(config.merge(errors_limit: nil))

            expect(subject.errors.size).to be > 1000
            expect(subject.errors.last).not_to eq(Error.new(type: 'too_many_errors', message: 'Too many errors were found'))
          end
        end

      end
    end

  end
end