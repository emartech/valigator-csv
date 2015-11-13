require 'spec_helper'


describe Valigator::CSV::Validator do
  describe '#validate' do
    subject { described_class.new(fixture(csv_file)) }


    context "the CSV is valid" do
      let(:csv_file) { "valid.csv" }


      it 'returns empty array for a valid file' do
        subject.validate

        expect(subject.errors).to eq []
      end
    end

    context 'the CSV has encoding problems' do
      let(:csv_file) { 'invalid-byte-sequence.csv' }

      it 'returns the lines have encoding problems' do
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


        subject.validate

        expect(subject.errors).to include(expected_error_1, expected_error_2)
      end
    end

  end
end


