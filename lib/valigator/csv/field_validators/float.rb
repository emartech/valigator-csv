module Valigator
  module CSV
    module FieldValidators
      class Float < Integer

        def initialize(options = {})
          @options = options
        end



        def valid?(value)
          formatted = formatted_value(value)

          formatted.to_f.to_s == formatted || super
        end



        def error_type
          'invalid_float'
        end



        def error_message
          'Invalid float field'
        end



        private

        def decimal_mark
          @options[:decimal_mark]
        end



        def formatted_value(value)
          decimal_mark ? value.gsub(decimal_mark, '.') : value
        end


      end
    end
  end
end
