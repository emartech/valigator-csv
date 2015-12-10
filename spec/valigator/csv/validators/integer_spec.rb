require 'spec_helper'

module Valigator
  module CSV
    module FieldValidators
      describe Integer do

        describe "#valid?" do
          {
            nil => false,
            "" => false,
            "1" => true,
            1 => true,
            1.1 => false,
            "abc" => false,
            "123a" => false
          }.each do |input, output|
            it "returns #{output} for value: #{input.inspect}" do
              expect(subject.valid?(input)).to eq(output)
            end
          end

          context "with allow_blank option" do
            subject { described_class.new allow_blank: true }

            {
              nil => true,
              "" => true,
              "1" => true,
              1 => true,
              1.1 => false,
              "abc" => false,
              "123a" => false
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
