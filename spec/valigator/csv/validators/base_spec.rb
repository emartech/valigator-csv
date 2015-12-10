require 'spec_helper'

module Valigator
  module CSV
    module FieldValidators

      class DummyValidator < Base
      end



      describe Base do
        describe "#==" do
          it { expect(subject == Base.new).to be_truthy }
          it { expect(subject == Base.new(some_option: true)).to be_falsey }
          it { expect(subject == DummyValidator.new).to be_falsey }
          it { expect(subject == 1).to be_falsey }
          it { expect(Base.new(some_option: true) == Base.new(some_option: true)).to be_truthy }
        end
      end

    end
  end
end
