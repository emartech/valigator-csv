require 'spec_helper'


describe Valigator::CSV::Validator do
  describe '#validate' do

    it 'returns empty array for a valid file' do
      subject = described_class.new(fixture("valid.csv"))

      expect(subject.validate).to eq []
    end


    it 'returns the problematic lines' do
      subject = described_class.new(fixture("invalid-byte-sequence.csv"))

      expected_errors = [
          {
              line: 1,
              error: "invalid byte sequence in UTF-8",
              content: "\"Data\",\"Dependencia Origem\",\"Hist\xF3rico\",\"Data do Balancete\",\"N\xFAmero do documento\",\"Valor\",\r\n"
          },
      ]

      expect(subject.validate).to eq expected_errors
    end

  end
end



def fixture(filename)
  File.join('spec/fixtures', filename)
end
