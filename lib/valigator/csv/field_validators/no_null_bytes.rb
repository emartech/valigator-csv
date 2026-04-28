module Valigator
  module CSV
    module FieldValidators
      class NoNullBytes < Base

        def valid?(value)
          return true if allow_blank and blank? value
          return true if value.nil?

          !value.to_s.include?("\x00")
        end



        def error_type
          'invalid_encoding'
        end



        def error_message
          'Invalid encoding: null byte (ASCII 0) detected'
        end

      end
    end
  end
end
