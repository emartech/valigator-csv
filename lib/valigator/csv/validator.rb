require 'csv'

module Valigator
  module CSV
    class Validator
      attr_reader :filename, :errors



      def initialize(filename)
        @filename = filename
        @errors = []
      end



      def validate
        ::CSV.foreach(@filename) { |_row| }
      rescue ::CSV::MalformedCSVError, ArgumentError => error
        @errors << CSV::Error.new(error)
      end

    end
  end
end