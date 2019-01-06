require 'dry/transaction'

require_relative './payments/container'

class CreatePayment
  include Dry::Transaction(container: Payments::Container)

  step :validate, with: 'payments.validate'
  step :pay, with: 'payments.pay'
end
