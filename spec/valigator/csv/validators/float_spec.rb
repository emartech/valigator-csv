require 'spec_helper'

describe Valigator::CSV::FieldValidators::Float do

  describe "#valid?" do
    context "default decimal separator" do
      {
        '1.1' => true,
        '1' => true,
        '1,1' => false,
        '1.0' => true,
        1.2 => true,
        2 => true,
        nil => false,
        '' => false
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
        1.2 => true,
        2 => true,
        nil => false,
        '' => false
      }.each do |input, output|
        it "returns #{output} for value: #{input.inspect}" do
          expect(subject.valid?(input)).to eq(output)
        end
      end
    end


    context "with allow_blank option" do
      subject { described_class.new allow_blank: true }

      {
        '1.1' => true,
        '1' => true,
        '1,1' => false,
        '1.0' => true,
        1.2 => true,
        2 => true,
        nil => true,
        '' => true
      }.each do |input, output|
        it "returns #{output} for value: #{input.inspect}" do
          expect(subject.valid?(input)).to eq(output)
        end
      end
    end
  end
end
