require 'csv'
require 'active_support/core_ext/string/filters'

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
      rescue ::CSV::MalformedCSVError => e
        @errors << Valigator::CSV::Error.new(e)
      end

    end
  end
end