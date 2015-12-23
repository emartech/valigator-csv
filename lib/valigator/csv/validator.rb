require 'csv'

module Valigator
  module CSV
    class Validator
      attr_reader :filename, :errors, :config



      def initialize(filename)
        @filename = filename
        @errors = []
        @config = default_config
      end



      def validate(options = {})
        config.merge! options

        ::CSV.foreach(filename, csv_options(options)) do |row|
          validate_fields row, options
          validate_row row, options

          stop_if_error_limit_reached
        end
      rescue ErrorsLimitReachedError
      rescue ::CSV::MalformedCSVError, Encoding::CompatibilityError, ArgumentError => error
        raise if unrelated_error?(error)

        errors << CSV::Error.new(error)
      end



      private


      def default_config
        {errors_limit: 1000}
      end



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



      def validate_fields(row, options = {})
        return unless options[:fields] && options[:field_validators]

        options[:fields].each_with_index do |field, index|
          validator = options[:field_validators][field]

          if validator && !validator.valid?(row[index])
            add_error_for(validator, field)
          end
        end
      end



      def stop_if_error_limit_reached
        if config[:errors_limit] && errors.size >= config[:errors_limit]
          errors << CSV::Error.new({type: 'too_many_errors', message: 'Too many errors were found'})
          raise ErrorsLimitReachedError
        end
      end



      def validate_row(row, options = {})
        return unless options[:fields] && options[:row_validators]

        options[:row_validators].each do |validator_class|
          validator = validator_class.new(options)
          next if validator.valid?(row)

          add_error_for validator
        end
      end



      def add_error_for(validator, field = nil)
        errors << CSV::Error.new({
          type: validator.error_type,
          message: validator.error_message,
          row: $INPUT_LINE_NUMBER,
          field: field
        })
      end

    end
  end
end