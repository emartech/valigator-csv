module Valigator
  module CSV
    class Error

      attr_accessor :row, :type, :message



      def initialize(err_info)
        case err_info
        when Hash
          err_info.each { |k, v| instance_variable_set("@#{k}", v) }
        when ::CSV::MalformedCSVError
          @row = /line (?<lineno>\d+)/.match(err_info.message)[:lineno].to_i
          @type = map_to_type(err_info.message)
          @message = err_info.message
        end
      end



      private


      def map_to_type(error_message)
        {
          /Missing or stray quote/ => 'stray_quote',
          /Unquoted fields do not allow/ => 'line_breaks',
          /Illegal quoting/ => 'illegal_quoting',
          /Field size exceeded/ => 'field_size'
        }.each do |message, type|
          return type if error_message =~ message
        end
      end

    end
  end
end
