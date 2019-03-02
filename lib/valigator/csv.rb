require 'valigator/csv/version'

module Valigator
  module CSV
    autoload :Error, 'valigator/csv/error'
    autoload :UnhandledTypeError, 'valigator/csv/error'
    autoload :ErrorsLimitReachedError, 'valigator/csv/error'
    autoload :Validator, 'valigator/csv/validator'
    autoload :FieldValidators, 'valigator/csv/field_validators'
    autoload :RowValidators, 'valigator/csv/row_validators'
  end
end
