module Valigator
  module CSV
    module FieldValidators
      class Base
        attr_reader :options

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



        def ==(other)
          self.class == other.class && options == other.options
        end



        private

        def blank?(value)
          value.to_s.empty?
        end



        def allow_blank
          options[:allow_blank]
        end

      end
    end
  end
end
