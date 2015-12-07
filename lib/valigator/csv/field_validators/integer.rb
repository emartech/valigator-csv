module Valigator
  module CSV
    module FieldValidators
      class Integer

        def valid?(value)
          return true if value.to_s.empty?

          value.to_i.to_s == value.to_s
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
