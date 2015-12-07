require 'spec_helper'

module Valigator
  module CSV
    module FieldValidators
      describe Date do

        describe "#valid?" do
          it "returns true for valid value" do
            expect(subject.valid?("2014-04-11")).to eq true
          end

          it "returns false for wrong value" do
            expect(subject.valid?("not-a-date")).to eq false
          end

          it "returns false for invalid date" do
            expect(subject.valid?("2014-04-31")).to eq false
          end

          context "with format option" do
            subject { described_class.new(format: "%m-%d-%Y")}

            it "returns true for valid value" do
              expect(subject.valid?("04-11-2014")).to eq true
            end

            it "returns false for invalid date" do
              expect(subject.valid?("2014-04-11")).to eq false
            end
          end
        end

      end
    end
  end
end
