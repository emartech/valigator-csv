require 'spec_helper'

module Valigator
  module CSV
    module FieldValidators
      describe Date do

        describe "#valid?" do
          {
            "2014-04-11" => true,
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
              "2014-04-11" => true,
              "2014-04-31" => false,
              "not-a-date" => false,
              nil => true,
              "" => true
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
