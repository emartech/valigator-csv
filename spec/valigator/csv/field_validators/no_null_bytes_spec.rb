RSpec.describe Valigator::CSV::FieldValidators::NoNullBytes do
  subject(:validator) { described_class.new(options) }
  let(:options) { {} }

  describe '#valid?' do
    context 'when value contains no null bytes' do
      it 'returns true for normal string' do
        expect(validator.valid?('Normal text')).to be true
      end

      it 'returns true for string with special characters' do
        expect(validator.valid?('Text with émojis 🎉')).to be true
      end

      it 'returns true for empty string' do
        expect(validator.valid?('')).to be true
      end

      it 'returns true for string with newlines and tabs' do
        expect(validator.valid?("Text with\nnewline\tand tab")).to be true
      end
    end

    context 'when value contains null bytes' do
      it 'returns false for string with null byte in middle' do
        expect(validator.valid?("Text with \x00 null byte")).to be false
      end

      it 'returns false for string with null byte at start' do
        expect(validator.valid?("\x00Start with null")).to be false
      end

      it 'returns false for string with null byte at end' do
        expect(validator.valid?("End with null\x00")).to be false
      end

      it 'returns false for string with multiple null bytes' do
        expect(validator.valid?("Multiple\x00null\x00bytes")).to be false
      end
    end

    context 'when value is nil' do
      it 'returns true' do
        expect(validator.valid?(nil)).to be true
      end
    end

    context 'with allow_blank option' do
      let(:options) { {allow_blank: true} }

      it 'returns true for empty string' do
        expect(validator.valid?('')).to be true
      end

      it 'returns true for nil' do
        expect(validator.valid?(nil)).to be true
      end

      it 'returns false for blank string with null byte' do
        expect(validator.valid?("\x00")).to be false
      end
    end
  end

  describe '#error_type' do
    it 'returns invalid_encoding' do
      expect(validator.error_type).to eq 'invalid_encoding'
    end
  end

  describe '#error_message' do
    it 'returns descriptive message about null bytes' do
      expect(validator.error_message).to eq 'Invalid encoding: null byte (ASCII 0) detected'
    end
  end
end
