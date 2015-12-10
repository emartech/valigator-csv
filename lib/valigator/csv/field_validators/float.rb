module Valigator
  module CSV
    module FieldValidators
      class Float < Integer

        def valid?(value)
          formatted = formatted_value(value)

          super || value.is_a?(::Float) || formatted.to_f.to_s == formatted
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
          decimal_mark ? value.to_s.gsub(decimal_mark, '.') : value
        end


      end
    end
  end
end
