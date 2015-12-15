require 'spec_helper'

describe Valigator::CSV::RowValidators::Ragged do

  describe "#valid?" do
    context "no fields are defined in options" do
      [
        [],
        [""],
        ["", ""],
        ["csv", "row", "23"]
      ].each do |input|
        it "returns true for row: #{input.inspect}" do
          expect(subject.valid?(input)).to be_truthy
        end
      end

    end


    context "fields are defined in options" do
      subject { described_class.new fields: %w(h1 h2) }

      {
        [] => false,
        [""] => false,
        ["", ""] => true,
        %w(csv row 23) => true,
      }.each do |input, result|
        it "returns #{result} for row: #{input.inspect}" do
          expect(subject.valid?(input)).to eq result
        end
      end

    end
  end
end