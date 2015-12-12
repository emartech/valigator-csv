module Valigator
  module CSV
    module FieldValidators
      class Float < Integer

        def valid?(value)
          super || value.is_a?(::Float) || formatted_float?(value)
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



        def formatted_float?(value)
          Float(formatted_value(value))
          true
        rescue ArgumentError, TypeError
          false
        end



        def formatted_value(value)
          decimal_mark ? value.to_s.gsub(decimal_mark, '.') : value
        end

      end
    end
  end
end
