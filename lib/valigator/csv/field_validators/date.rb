module Valigator
  module CSV
    module FieldValidators
      class Date < Base

        def valid?(value)
          return true if allow_blank and blank? value

          parse value
          true
        rescue ArgumentError
          false
        end



        def error_type
          'invalid_date'
        end



        def error_message
          'Invalid date field'
        end



        private

        def strict_parse_date(value, format)
          if value.nil? || value == ""
            trimmed_value = ''
          else
            pattern = format.match?('\/|-|\.') ? '\d+\D\d+\D\d+' : '\d+'
            match = value.match(pattern)
            trimmed_value = match ? match[0] : ''
          end
          date = ::Date.strptime(trimmed_value, format)
          if date.year < 1000
            raise ArgumentError, "Date does not match the expected format: #{value}"
          end
          date
        end

        def format
          @options[:format]
        end

        def strict_validate_date_format
          @options[:strict_validate_date_format] || false
        end

        def parse(value)
          if format
            if strict_validate_date_format
              strict_parse_date(value.to_s, format)
            else
              ::Date.strptime(value.to_s, format)
            end
          else
            ::Date.parse(value.to_s)
          end
        end
      end
    end
  end
end
