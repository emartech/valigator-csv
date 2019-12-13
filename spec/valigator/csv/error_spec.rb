RSpec.describe Valigator::CSV::Error do
  let(:row) { 123 }
  let(:type) { "error_type" }
  let(:message) { "Missing or stray quote" }

  describe "#initialize" do
    context "from hash" do
      it "assigns known fields" do
        error = described_class.new({row: row, type: type, message: message})

        expect(error.row).to eq(row)
        expect(error.type).to eq(type)
      end

      it "does not assign unknown fields" do
        error = described_class.new({nope: "nope"})
        expect(error).not_to respond_to(:nope)
      end
    end

    context "from MalformedCSVError exception in Ruby 2.5 and earlier", ruby: '< 2.6' do
      let(:examples) do
        [
          {message: "Unquoted fields do not allow \\r or \\n (line #{row}).", type: 'line_breaks'},
          {message: "Missing or stray quote in line #{row}", type: 'illegal_quoting'},
          {message: "Illegal quoting in line #{row}.", type: 'illegal_quoting'},
          {message: "Field size exceeded on line #{row}.", type: 'field_size'},
          {message: "Unclosed quoted field on line #{row}.", type: 'unclosed_quote'},
          {message: "TODO: Meaningful message in line #{row}.", type: 'unknown_error'}
        ]
      end

      it "maps each error correctly" do
        examples.each do |example|
          error = described_class.new(::CSV::MalformedCSVError.new(example[:message]))

          expect(error.row).to eq(row)
          expect(error.type).to eq(example[:type])
        end
      end

      it "keeps the original message" do
        error = described_class.new(::CSV::MalformedCSVError.new(message))

        expect(error.message).to eq(message)
      end
    end

    context "from MalformedCSVError exception in Ruby 2.6 and later", ruby: '>= 2.6' do
      let(:examples) do
        [
          {message: "Unquoted fields do not allow \\r or \\n", type: 'line_breaks'},
          {message: "Unquoted fields do not allow new line <\"\\r\">", type: 'line_breaks'},
          {message: "Missing or stray quote", type: 'illegal_quoting'},
          {message: "Illegal quoting", type: 'illegal_quoting'},
          {message: "Any value after quoted field isn't allowed", type: 'illegal_quoting'},
          {message: "Field size exceeded", type: 'field_size'},
          {message: "Unclosed quoted field", type: 'unclosed_quote'},
          {message: "TODO: Meaningful message", type: 'unknown_error'}
        ]
      end
      let(:csv_error) { ::CSV::MalformedCSVError.new(message, row) }

      it "maps each error correctly" do
        examples.each do |example|
          error = described_class.new(::CSV::MalformedCSVError.new(example[:message], row))

          expect(error.row).to eq(row)
          expect(error.type).to eq(example[:type])
        end
      end

      it "keeps the original message" do
        error = described_class.new(csv_error)

        expect(error.message).to start_with(message)
      end
    end

    context "from Encoding::CompatibilityError" do
      it "maps the error correctly" do
        error = described_class.new(Encoding::CompatibilityError.new("incompatible character encodings: UTF-8 and UTF-16"))
        expect(error.type).to eq "invalid_encoding"
      end
    end
  end

  describe "#to_hash" do
    it "should return the error as a hash" do
      error = described_class.new row: 1, type: 'illegal_quoting', message: "Missing or stray quote in line 1", field: 'id', details: {key: "value"}

      expect(error.to_hash).to eq row: 1, type: 'illegal_quoting', message: "Missing or stray quote in line 1", field: 'id', details: {key: "value"}
    end
  end
end
