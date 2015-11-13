module Valigator
  module CSV
    class Validator
      attr_reader :filename, :errors



      def initialize(filename)
        @filename = filename
      end



      def validate
        @errors = []

        check_encoding
      end



      private

      def check_encoding
        File.foreach(filename).with_index(1) do |line, i|
          begin
            line =~ //
          rescue ArgumentError => e
            add_to_errors i, e.message, line
          end
        end
      end



      def add_to_errors(line_number, error_message, content)
        @errors << {
            line: line_number,
            error: error_message,
            content: content
        }
      end

    end
  end
end
