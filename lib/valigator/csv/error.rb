module Valigator
  module CSV
    class ErrorsLimitReachedError < StandardError
    end


    class UnhandledTypeError < StandardError
    end


    class Error

      attr_reader :row, :type, :message, :field, :details



      def initialize(error)
        case error
          when Hash
            build_from_hash error
          when StandardError
            build_from_error error
        end
      end



      def ==(other)
        row == other.row && message == other.message && type == other.type && field == other.field && details == other.details
      end



      def to_hash
        {
          row: row,
          type: type,
          message: message,
          field: field,
          details: details
        }
      end



      private

      def build_from_hash(error)
        build error[:type], error[:message], error[:row], error[:field], error[:details]
      end



      def build_from_error(error)
        error_message = standardize_message(error.message)
        build map_to_type(error_message), error_message, determine_row(error_message)
      end



      def standardize_message(message)
        message.sub('Do not allow except col_sep_split_separator after quoted fields', 'Missing or stray quote')
      end



      def determine_row(message)
        matches = /line (?<lineno>\d+)/.match(message)
        matches[:lineno].to_i if matches
      end



      def build(type, message, row, field = nil, details = nil)
        @type = type
        @row = row
        @message = message
        @field = field
        @details = details
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
          when /invalid byte sequence/i, /incompatible encoding/i, /incompatible character encodings/i
            'invalid_encoding'
          else
            raise UnhandledTypeError, message
        end
      end


    end
  end
end
