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
          date = ::Date.strptime(value, format)
          if date.strftime(format) != value
            raise ArgumentError, "Date does not match the expected format: #{value}"
          end
          date
        end

        def format
          @options[:format]
        end



        def parse(value)
          format ? strict_parse_date(value.to_s, format) : ::Date.parse(value.to_s)
        end

      end
    end
  end
end
