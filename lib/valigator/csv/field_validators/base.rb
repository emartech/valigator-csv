module Valigator
  module CSV
    module FieldValidators
      class Base

        def initialize(options={})
          @options = options
        end



        def valid?(value)
          raise NotImplementedError
        end



        def error_type
          raise NotImplementedError
        end



        def error_message
          raise NotImplementedError
        end



        private

        def blank?(value)
          value.to_s.empty?
        end



        def allow_blank
          @options[:allow_blank]
        end

      end
    end
  end
end
