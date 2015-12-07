module Valigator
  module CSV
    module FieldValidators
      class Mandatory

        def valid?(value)
          !value.to_s.empty?
        end



        def error_type
          'missing_field'
        end



        def error_message
          'Missing mandatory field'
        end
      end
    end
  end
end
