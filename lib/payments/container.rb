require 'dry/container'

require_relative './pay'
require_relative './validate'

module Payments
  class Container
    extend Dry::Container::Mixin

    namespace 'payments' do
      register 'validate' do
        Validate.new
      end

      register 'pay' do
        Pay.new
      end
    end
  end
end
