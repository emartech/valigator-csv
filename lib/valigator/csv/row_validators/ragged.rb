module Valigator
  module CSV
    module RowValidators
      class Ragged
        attr_reader :options



        def initialize(options = {})
          @options = options
        end



        def valid?(row)
          return true unless fields

          row.size >= fields.size
        end



        def error_type
          'ragged_row'
        end



        def error_message
          'Ragged or empty row'
        end



        def ==(other)
          self.class == other.class && options == other.options
        end



        private

        def fields
          options[:fields]
        end

      end
    end
  end
end
