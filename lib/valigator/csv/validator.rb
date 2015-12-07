require 'csv'

module Valigator
  module CSV
    class Validator
      attr_reader :filename, :errors



      def initialize(filename)
        @filename = filename
        @errors = []
      end



      def validate(options = {})
        ::CSV.foreach(@filename, csv_options(options)) do |row|
          validate_fields row, options
        end
      rescue ::CSV::MalformedCSVError, ArgumentError => error
        raise if unrelated_error?(error)

        @errors << CSV::Error.new(error)
      end



      private

      def csv_options(options = {})
        {
          col_sep: options[:col_sep] || ',',
          quote_char: options[:quote_char] || '"',
          encoding: options[:encoding] || 'UTF-8',
          headers: options[:headers] || false,
          return_headers: options[:return_headers] || false
        }
      end



      def unrelated_error?(error)
        error.is_a?(ArgumentError) && error.message != 'invalid byte sequence in UTF-8'
      end



      def validate_fields(row, options={})
        return unless options[:fields] && options[:field_validators]

        options[:fields].each_with_index do |field, index|
          options[:field_validators][field].to_a.each do |field_validator|
            add_field_error(field, field_validator) unless field_validator.valid? row[index]
          end
        end
      end



      def add_field_error(field, validator)
        @errors << CSV::Error.new({
          type: validator.error_type,
          message: validator.error_message,
          row: $INPUT_LINE_NUMBER,
          field: field
        })
      end

    end
  end
end