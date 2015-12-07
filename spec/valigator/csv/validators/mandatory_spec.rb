require 'spec_helper'

module Valigator
  module CSV
    module FieldValidators
      describe Mandatory do

        describe "#valid?" do
          it "returns true for valid value" do
            expect(subject.valid?("something")).to eq true
          end

          it "returns false for nil value" do
            expect(subject.valid?(nil)).to eq false
          end

          it "returns false for empty string" do
            expect(subject.valid?("")).to eq false
          end
        end

      end
    end
  end
end
