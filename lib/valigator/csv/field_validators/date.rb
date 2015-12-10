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

        def format
          @options[:format]
        end



        def parse(value)
          format ? ::Date.strptime(value.to_s, format) : ::Date.parse(value.to_s)
        end

      end
    end
  end
end
