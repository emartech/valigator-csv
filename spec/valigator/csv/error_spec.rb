require 'spec_helper'
require 'csv'

module Valigator
  module CSV

    describe Error do
      row = 123
      type = "error_type"
      message = "Missing or stray quote in line #{row}"

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


        context "from MalformedCSVError" do
          [
            [::CSV::MalformedCSVError.new("Missing or stray quote in line #{row}"), 'stray_quote'],
            [::CSV::MalformedCSVError.new("Unquoted fields do not allow \\r or \\n (line #{row})."), 'line_breaks'],
            [::CSV::MalformedCSVError.new("Illegal quoting in line #{row}."), 'illegal_quoting'],
            [::CSV::MalformedCSVError.new("Field size exceeded on line #{row}."), 'field_size'],
            [::CSV::MalformedCSVError.new("Unclosed quoted field on line #{row}."), 'unclosed_quote']
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


          it "raises excaption for unhandled error types" do
            error_message = 'I forgot to handle this error on line 666'

            expect { described_class.new(::CSV::MalformedCSVError.new(error_message)) }.to raise_error(UnhandledTypeError, error_message)
          end
        end
      end


      describe "#to_hash" do
        it "should return the error as a hash" do
          error = described_class.new row: 1, type: 'stray_quote', message: "Missing or stray quote in line 1"

          expect(error.to_hash).to eq row: 1, type: 'stray_quote', message: "Missing or stray quote in line 1"
        end
      end
    end
  end
end
