module Valigator
  module CSV
    class Validator
      attr_reader :filename



      def initialize(filename)
        @filename = filename
      end



      def validate
        errors = []
        File.foreach(filename).with_index(1) do |line, i|
          begin
            line =~ //
          rescue ArgumentError => e
            errors << {
                line: 1,
                error: e.message,
                content: line
            }
            break
          end
        end

        errors
      end

    end
  end
end
