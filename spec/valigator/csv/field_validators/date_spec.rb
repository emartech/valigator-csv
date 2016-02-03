require 'spec_helper'

module Valigator
  module CSV
    module FieldValidators
      describe Date do

        describe "#valid?" do
          {
            "2014-04-11" => true,
            "April 11, 2014" => true,
            "01/02/03" => true,
            "1999-Jan-08" => true,
            "Jan-08-1999" => true,
            "08-Jan-1999" => true,
            "08-Jan-99" => true,
            "Jan-08-99" => true,
            "19990108" => true,
            "990108" => true,
            "J2451187" => true,
            "January 8, 99 BC" => true,

            "1999.008" => false,
            "99-Jan-08" => false,
            "4/18/2014" => false,
            "1/18/1999" => false,
            "2014-04-31" => false,
            "not-a-date" => false,
            nil => false,
            "" => false
          }.each do |input, output|
            it "returns #{output} for value: #{input.inspect}" do
              expect(subject.valid?(input)).to eq(output)
            end
          end

          context "with format option" do
            subject { described_class.new format: "%m-%d-%Y" }

            {
              "04-11-2014" => true,
              "2014-04-11" => false,
              "not-a-date" => false,
              nil => false,
              "" => false
            }.each do |input, output|
              it "returns #{output} for value: #{input.inspect}" do
                expect(subject.valid?(input)).to eq(output)
              end
            end
          end

          context "with allow_blank option" do
            subject { described_class.new allow_blank: true }

            {
              nil => true,
              "" => true,
              "2014-04-11" => true,
              "2014-04-31" => false,
              "not-a-date" => false
            }.each do |input, output|
              it "returns #{output} for value: #{input.inspect}" do
                expect(subject.valid?(input)).to eq(output)
              end
            end
          end

        end

      end
    end
  end
end
