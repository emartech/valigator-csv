require 'csvlint'
require 'active_support/core_ext/string/filters'

module Valigator
  module CSV
    class Validator
      attr_reader :filename, :errors



      def initialize(filename)
        @filename = filename
      end



      def validate(options = {})
        @errors = []

        check_with_csvlint(options)
      end



      private

      def check_with_csvlint(options = {})
        validator = ::Csvlint::Validator.new(File.open(filename), {}, build_schema(options))

        validator.errors.each { |error| add_to_errors error }
        validator.warnings.each { |warning| add_to_errors warning }
      end



      def build_schema(options = {})
        ::Csvlint::Schema.new("", build_header_fields(options))
      end



      def build_header_fields(options = {})
        return unless options[:headers]

        options[:headers].map { |header| ::Csvlint::Field.new(header) }
      end



      def add_to_errors(error)
        @errors << {
          line: error.row,
          error: error.type.to_s,
          content: error.content.to_s.truncate(80)
        }
      end

    end
  end
end
