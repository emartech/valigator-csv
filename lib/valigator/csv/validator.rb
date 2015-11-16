require 'csvlint'
require 'active_support/core_ext/string/filters'

module Valigator
  module CSV
    class Validator
      attr_reader :filename, :errors



      def initialize(filename)
        @filename = filename
      end



      def validate
        @errors = []

        check_with_csvlint
      end



      private

      def check_with_csvlint
        validator = ::Csvlint::Validator.new(File.open(filename))

        validator.errors.each do |error|
          add_to_errors error.row, error.type.to_s, error.content
        end
      end



      def add_to_errors(line_number, error_message, content)
        @errors << {
          line: line_number,
          error: error_message,
          content: content.to_s.truncate(80)
        }
      end

    end
  end
end
