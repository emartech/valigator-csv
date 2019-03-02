RSpec.describe Valigator::CSV::Validator do
  subject(:validator) { described_class.new fixture(filename) }
  let(:filename) { 'valid.csv' }

  describe '#validate' do
    def expect_one_csv_error(type:, message:, row: nil, field: nil)
      expect(validator.errors.count).to eq 1
      error = validator.errors.first
      expect(error).to be_a Valigator::CSV::Error
      expect(error.type).to eq type
      expect(error.message).to match message
      expect(error.row).to eq row if row
      expect(error.field).to eq field if field
    end

    it "forwards csv header options" do
      expect(::CSV).to receive(:foreach).with(fixture('valid.csv'), col_sep: ',', quote_char: '"', encoding: 'UTF-8', headers: true, return_headers: false)
      subject.validate headers: true, return_headers: false
    end


    it '(re)raises all errors, if they are not directly parsing related' do
      expect { validator.validate quote_char: 'asd' }.to raise_error ArgumentError, ':quote_char has to be a single character String'
    end


    context 'for valid files' do
      let(:filename) { 'valid.csv' }

      it 'collects no errors' do
        validator.validate
        expect(validator.errors).to be_empty
      end

      context 'with a custom dialect' do
        let(:filename) { 'valid_custom.csv' }

        it 'collects no errors' do
          validator.validate(col_sep: ";", quote_char: "'")
          expect(validator.errors).to be_empty
        end
      end
    end


    context 'for files with invalid encoding' do
      let(:filename) { 'invalid_encoding.csv' }

      it 'detects invalid byte sequence when opening with default encoding' do
        validator.validate
        expect_one_csv_error type: 'invalid_encoding', message: /invalid byte sequence in UTF-8/i
      end

      it 'does not report byte sequence error when opened with the correct encoding' do
        validator.validate(encoding: 'ISO-8859-9')
        expect(validator.errors).to be_empty
      end
    end


    context 'when a field validator tries to convert into another encoding' do
      let(:field_validator) { instance_double(Valigator::CSV::FieldValidators::Base) }

      before do
        allow(field_validator).to receive(:valid?) do |value|
          "some string".force_encoding(Encoding::UTF_8).include?(value.force_encoding(Encoding::UTF_16))
        end
      end

      it 'reports invalid encoding if a field validator tries to convert into another encoding' do
        config = {
          fields: %w(Foo),
          field_validators: {
            "Foo" => field_validator
          }
        }
        validator.validate(config)

        expect(validator.errors).to eq([Valigator::CSV::Error.new(row: nil, type: 'invalid_encoding', message: 'incompatible character encodings: UTF-8 and UTF-16')])
      end
    end


    context 'when the file has an unclosed quote' do
      let(:filename) { 'unclosed_quote.csv' }

      it 'detects unclosed quotes' do
        validator.validate
        expect_one_csv_error type: 'unclosed_quote', message: /Unclosed quoted field/, row: 4
      end
    end


    context 'when the file has a stray quote' do
      let(:filename) { 'stray_quote.csv' }

      it 'detects stray quotes' do
        validator.validate
        expect_one_csv_error type: 'stray_quote', message: /Missing or stray quote/, row: 2
      end
    end


    context 'when the file has inconsistent line breaks' do
      let(:filename) { 'inconsistent_line_breaks.csv' }

      it 'detects inconsistent line breaks' do
        validator.validate
        expect_one_csv_error type: 'line_breaks', message: /Unquoted fields do not allow \\r or \\n/, row: 2
      end
    end


    context 'for mandatory fields' do
      let(:filename) { 'missing_mandatory_field.csv' }

      it 'does not validate unless fields given' do
        options = {field_validators: {"id" => Valigator::CSV::FieldValidators::Mandatory.new}}
        validator.validate(options)
        expect(validator.errors).to eq []
      end

      it 'does not validate unless field validators given' do
        options = {fields: %w(id name)}
        validator.validate(options)
        expect(validator.errors).to eq []
      end

      it 'reports field with nil value as error' do
        options = {
          fields: %w(id name),
          field_validators: {"id" => Valigator::CSV::FieldValidators::Mandatory.new}
        }
        validator.validate(options)
        expect_one_csv_error type: 'missing_field', message: 'Missing mandatory field', row: 4, field: 'id'
      end
    end


    context 'when file contains ragged rows' do
      let(:filename) { 'ragged_rows.csv' }

      it 'does not validate number of fields if there are no fields options defined' do
        validator.validate
        expect(validator.errors).to eq []
      end

      it 'detects rows with different number of fields than the options' do
        options = {
          fields: %w(id name),
          row_validators: [Valigator::CSV::RowValidators::Ragged]
        }
        validator.validate(options)
        expect_one_csv_error type: 'ragged_row', message: 'Ragged or empty row', row: 3
      end
    end


    context 'when the file contains too many errors' do
      let(:filename) { 'too_many_errors.csv' }
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

      it 'stops collecting errors when reaching default error threshold' do
        validator.validate(config)
        expect(validator.errors.size).to eq(1000 + 3)
        expect(validator.errors.last).to eq(Valigator::CSV::Error.new(type: 'too_many_errors', message: 'Too many errors were found'))
      end

      it 'stops collecting errors when reaching value given as option' do
        validator.validate(config.merge(errors_limit: 1))
        expect(validator.errors.size).to eq(1 + 6)
        expect(validator.errors.last).to eq(Valigator::CSV::Error.new(type: 'too_many_errors', message: 'Too many errors were found'))
      end

      it 'collects all errors when limit is disabled' do
        validator.validate(config.merge(errors_limit: nil))
        expect(validator.errors.size).to be > 1000
        expect(validator.errors.last).not_to eq(Valigator::CSV::Error.new(type: 'too_many_errors', message: 'Too many errors were found'))
      end
    end


    context "when details proc is given in the config" do
      let(:filename) { "invalid_field_type.csv" }
      let(:config) do
        {
          headers: true,
          fields: ["source_id", "order"],
          field_validators: {"order" => Valigator::CSV::FieldValidators::Integer.new(allow_blank: false)},
          details: -> (erroneous_row) { {contact_id: erroneous_row["source_id"]} if erroneous_row.has_key?("source_id") }
        }
      end

      it "adds details into the current error" do
        validator.validate(config)
        expect(validator.errors).to eq([Valigator::CSV::Error.new(type: "invalid_integer", message: "Invalid integer field", row: 2, field: "order", details: {contact_id: "123"})])
      end
    end

  end
end
