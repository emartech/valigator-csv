module Valigator
  module CSV
    class Error

      attr_reader :row, :type, :message



      def initialize(error)
        case error
        when Hash
          build_from_hash error
        when ::CSV::MalformedCSVError
          build_from_error error
        end
      end



      def ==(other)
        row == other.row && message == other.message && type == other.type
      end



      private

      def build_from_hash(error)
        build error[:type], error[:message], error[:row]
      end



      def build_from_error(error)
        build map_to_type(error.message), error.message, determine_row(error.message)
      end



      def determine_row(message)
        /line (?<lineno>\d+)/.match(message)[:lineno].to_i
      end



      def build(type, message, row)
        @type = type
        @row = row
        @message = message
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
        else
          raise ArgumentError, 'unknown type'
        end
      end


    end
  end
end
