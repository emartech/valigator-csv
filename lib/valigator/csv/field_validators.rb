module Valigator
  module CSV
    module FieldValidators
      autoload :Date, 'valigator/csv/field_validators/date'
      autoload :Integer, 'valigator/csv/field_validators/integer'
      autoload :Mandatory, 'valigator/csv/field_validators/mandatory'
    end
  end
end
