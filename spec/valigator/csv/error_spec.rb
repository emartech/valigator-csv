require 'spec_helper'
require 'csv'


describe Valigator::CSV::Error do
  row = 123
  type = "error_type"
  message = "Missing or stray quote in line #{row}"

  context "init from hash" do
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


  context "init from MalformedCSVError" do
    [
      [::CSV::MalformedCSVError.new("Missing or stray quote in line #{row}"), 'stray_quote'],
      [::CSV::MalformedCSVError.new("Unquoted fields do not allow \\r or \\n (line #{row})."), 'line_breaks'],
      [::CSV::MalformedCSVError.new("Illegal quoting in line #{row}."), 'illegal_quoting'],
      [::CSV::MalformedCSVError.new("Field size exceeded on line #{row}."), 'field_size']
    ].each do |original_error, type|
      it "maps correctly" do
        error = described_class.new(original_error)

        expect(error.row).to eq(row)
        expect(error.type).to eq(type)
      end
    end

    it "keeps the original message" do
      error = described_class.new(::CSV::MalformedCSVError.new(message))

      expect(error.message).to eq(message)
    end
  end
end
