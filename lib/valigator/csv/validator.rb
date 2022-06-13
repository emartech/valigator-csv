module Valigator
  module CSV
    class Validator
      attr_reader :filename, :errors, :config



      def initialize(filename)
        @filename = filename
        @current_row_number = 0
        @errors = []
        @config = default_config
      end



      def validate(options = {})
        config.merge! options
        @current_row_number = csv_options(options)[:headers] ? 1 : 0

        ::CSV.foreach(filename, **csv_options(options)) do |row|
          @current_row_number += 1
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
        error.is_a?(ArgumentError) && error.message !~ /invalid byte sequence in/
      end



      def validate_fields(row, options = {})
        return unless options[:fields] && options[:field_validators]

        options[:fields].each_with_index do |field, index|
          validator = options[:field_validators][field]

          if validator && !validator.valid?(row[index])
            add_error_for(validator, field, row)
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

      def add_error_for(validator, field = nil, row = nil)
        error_hash = error_hash(validator, field)
        error_hash.merge!({details: error_details(row)}) if error_details(row)

        errors << CSV::Error.new(error_hash)
      end

      def error_hash(validator, field = nil)
        {
          type: validator.error_type,
          message: validator.error_message,
          row: @current_row_number,
          field: field
        }
      end

      def error_details(row)
        config[:details].call(row) if config.has_key?(:details)
      end
    end
  end
end
