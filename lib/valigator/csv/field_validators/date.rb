module Valigator
  module CSV
    module FieldValidators
      class Date

        def initialize(options={})
          @options = options
        end



        def valid?(value)
          format ? ::Date.strptime(value, format) : ::Date.parse(value)
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

      end
    end
  end
end
