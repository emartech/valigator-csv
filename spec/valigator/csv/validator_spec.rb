require 'spec_helper'


describe Valigator::CSV::Validator do
  describe '#validate' do

    it 'returns errors in an array' do
      subject = described_class.new(fixture("invalid-byte-sequence.csv"))

      expect(subject.validate).to be_an(Array)
    end


    it 'returns empty array for a valid file' do
      subject = described_class.new(fixture("valid.csv"))

      expect(subject.validate).to eq []
    end


    it 'returns the problematic lines' do
      subject = described_class.new(fixture("invalid-byte-sequence.csv"))

      expected_error_1 = {
          line: 1,
          error: "invalid byte sequence in UTF-8",
          content: "\"Data\",\"Dependencia Origem\",\"Hist\xF3rico\",\"Data do Balancete\",\"N\xFAmero do documento\",\"Valor\",\r\n"
      }
      expected_error_2 = {
          line: 3,
          error: "invalid byte sequence in UTF-8",
          content: "\"11/01/2012\",\"0000-9\",\"Transfer\xEAncia on line - 01/11 4885     256620-6 XXXXXXXXXXXXX\",\"\",\"224885000256620\",\"100.00\",\r\n"
      }

      expect(subject.validate).to include(expected_error_1, expected_error_2)
    end

  end
end



def fixture(filename)
  File.join('spec/fixtures', filename)
end
