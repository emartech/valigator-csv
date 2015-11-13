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
                line: i,
                error: e.message,
                content: line
            }
          end
        end

        errors
      end

    end
  end
end
