module Valigator
  module CSV
    module FieldValidators
      class Integer < Base

        def valid?(value)
          return true if allow_blank and blank? value

          value.is_a?(::Integer) || value.to_i.to_s == value.to_s
        end



        def error_type
          'invalid_integer'
        end



        def error_message
          'Invalid integer field'
        end
      end
    end
  end
end
