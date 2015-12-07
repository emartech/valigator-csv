module Valigator
  module CSV
    class UnhandledTypeError < StandardError
    end


    class Error

      attr_reader :row, :type, :message, :field



      def initialize(error)
        case error
          when Hash
            build_from_hash error
          when StandardError
            build_from_error error
        end
      end



      def ==(other)
        row == other.row && message == other.message && type == other.type && field == other.field
      end



      def to_hash
        {
          row: row,
          type: type,
          message: message,
          field: field
        }
      end



      private

      def build_from_hash(error)
        build error[:type], error[:message], error[:row], error[:field]
      end



      def build_from_error(error)
        build map_to_type(error.message), error.message, determine_row(error.message)
      end



      def determine_row(message)
        matches = /line (?<lineno>\d+)/.match(message)
        matches[:lineno].to_i if matches
      end



      def build(type, message, row, field=nil)
        @type = type
        @row = row
        @message = message
        @field = field
      end



      def map_to_type(message)
        case message
          when /Missing or stray quote/
            'stray_quote'
          when /Unquoted fields do not allow/
            'line_breaks'
          when /Illegal quoting/
            'illegal_quoting'
          when /Field size exceeded/
            'field_size'
          when /Unclosed quoted field/
            'unclosed_quote'
          when /invalid byte sequence/
            'invalid_encoding'
          else
            raise UnhandledTypeError, message
        end
      end


    end
  end
end
