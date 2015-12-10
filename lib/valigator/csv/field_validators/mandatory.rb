module Valigator
  module CSV
    module FieldValidators
      class Mandatory < Base

        def valid?(value)
          not blank? value
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
