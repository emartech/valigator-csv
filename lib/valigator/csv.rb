module Valigator
  module CSV
    autoload :Error, 'valigator/csv/error'
    autoload :UnhandledTypeError, 'valigator/csv/error'
    autoload :Validator, 'valigator/csv/validator'
    autoload :FieldValidators, 'valigator/csv/field_validators'
    autoload :Version, 'valigator/csv/version'
  end
end
