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

          context "with format option %Y-%m-%d" do
            subject { described_class.new format: "%Y-%m-%d", strict_validate_date_format: true }

            {
              "04-11-2014" => false,
              "2024-04-11" => true,
              nil => false,
              "" => false,
            }.each do |input, output|
              it "returns #{output} for value: #{input.inspect}" do
                expect(subject.valid?(input)).to eq(output)
              end
            end
          end

          context "with format option %Y-%m-%d as timestamp" do
            subject { described_class.new format: "%Y-%m-%d", strict_validate_date_format: true }

            {
              "04-11-2014" => false,                # Invalid format
              "2024-04-11" => true,
              "2025-06-11T00:16:38+02:00" => true,
              "2025-06-11T00:16:38Z" => true,
              "T00:16:38Z" => false,                # Invalid format
              "00:16:38+02:00T2025-06-11" => false, # Invalid format
              "2025-13-11T00:16:38+02:00" => false, # Invalid month
              "2025-06-32T00:16:38+02:00" => false, # Invalid day
              "2025-06-11T00:16:38" => true,        # Valid timestamp without timezone
              "2025-06-11.00:16:38+00:00" => true,  # Valid timestamp with UTC timezone
              "2025-06-11-00:16:38+00:00" => true,  # Valid timestamp with UTC timezone
              "2025-06-11 00:16:38+00:00" => true,  # Valid timestamp with UTC timezone
              nil => false,
              "" => false,
              " " => false,
              "\n" => false,
              "\t" => false,
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
