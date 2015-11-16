require 'csvlint'
require 'active_support/core_ext/string/filters'
require 'active_support/hash_with_indifferent_access'

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
        File.open(filename, "r:#{options[:encoding] || 'UTF-8'}") do |file|
          validator = ::Csvlint::Validator.new(file, {}, build_schema(options))

          validator.errors.each { |error| add_to_errors error }
          validator.warnings.each { |warning| add_to_errors warning }
        end
      end



      def build_schema(options = {})
        return unless options[:headers]

        ::Csvlint::Schema.new("", build_header_fields(options))
      end



      def build_header_fields(options = {})
        options[:headers].map do |header|
          header_definition = JSON.parse JSON.dump(header)

          ::Csvlint::Field.new(header_definition["name"], header_definition["constraints"])
        end
      end



      def add_to_errors(original_error)
        return if original_error.type == :encoding

        error = {
          row: original_error.row,
          column: original_error.column,
          type: original_error.type.to_s,
          content: original_error.content.to_s.truncate(80)
        }

        @errors << error.reject { |_, v| v.blank? }
      end

    end
  end
end