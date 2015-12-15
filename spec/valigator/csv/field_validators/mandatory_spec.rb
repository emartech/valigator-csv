require 'spec_helper'

module Valigator
  module CSV
    module FieldValidators
      describe Mandatory do

        describe "#valid?" do
          {
            "something" => true,
            nil => false,
            "" => false
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
