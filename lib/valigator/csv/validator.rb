require 'csv'

module Valigator
  module CSV
    class Validator
      attr_reader :filename, :errors



      def initialize(filename)
        @filename = filename
        @errors = []
      end



      def validate(options = {})
        ::CSV.foreach(@filename, build_options(options)) { |_row|}
      rescue ::CSV::MalformedCSVError, ArgumentError => error
        @errors << CSV::Error.new(error)
      end



      private

      def build_options(options = {})
        {
          col_sep: options[:col_sep] || ',',
          quote_char: options[:quote_char] || '"',
          encoding: options[:encoding] || 'UTF-8'
        }
      end

    end
  end
end