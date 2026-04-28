module Valigator
  module CSV
    module FieldValidators
      autoload :Base, 'valigator/csv/field_validators/base'
      autoload :Date, 'valigator/csv/field_validators/date'
      autoload :Float, 'valigator/csv/field_validators/float'
      autoload :Integer, 'valigator/csv/field_validators/integer'
      autoload :Mandatory, 'valigator/csv/field_validators/mandatory'
      autoload :NoNullBytes, 'valigator/csv/field_validators/no_null_bytes'
    end
  end
end
