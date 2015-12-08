require 'spec_helper'

describe Valigator::CSV::FieldValidators::Float do

  describe "#valid?" do
    context "default decimal separator" do
      {
        '1.1' => true,
        '1' => true,
        '1,1' => false,
        '1.0' => true,
        '' => true
      }.each do |input, output|
        it "returns #{output} for value: #{input.inspect}" do
          expect(subject.valid?(input)).to eq(output)
        end
      end
    end


    context "custom decimal separator" do
      subject { described_class.new decimal_mark: ',' }

      {
        '1.1' => true,
        '1' => true,
        '1,1' => true,
        '1,0' => true,
        '' => true
      }.each do |input, output|
        it "returns #{output} for value: #{input.inspect}" do
          expect(subject.valid?(input)).to eq(output)
        end
      end
    end

  end
end
