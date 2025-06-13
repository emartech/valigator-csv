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
          today = ::Date.today.strftime(format).to_s
          trimmed_value = value.nil? || value == ""  ? '' : value.to_s[0, today.length]
          date = ::Date.strptime(trimmed_value, format)
          if date.strftime(format) != trimmed_value
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
