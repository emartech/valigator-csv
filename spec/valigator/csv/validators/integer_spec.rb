require 'spec_helper'

module Valigator
  module CSV
    module FieldValidators
      describe Integer do

        describe "#valid?" do
          it "returns true for valid value" do
            expect(subject.valid?("1")).to eq true
          end

          it "returns true for valid value" do
            expect(subject.valid?(1)).to eq true
          end

          it "returns true for nil value" do
            expect(subject.valid?(nil)).to eq true
          end

          it "returns true for empty string" do
            expect(subject.valid?("")).to eq true
          end

          it "returns false for float value" do
            expect(subject.valid?(1.1)).to eq false
          end

          it "returns false for string value" do
            expect(subject.valid?("abc")).to eq false
          end

          it "returns false for invalid value" do
            expect(subject.valid?("123a")).to eq false
          end
        end

      end
    end
  end
end
