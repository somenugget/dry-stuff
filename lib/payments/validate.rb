require 'dry/transaction/operation'

module Payments
  class Validate
    include Dry::Transaction::Operation

    def call(input)
      balance = 100

      if input.sum > balance
        Failure('Not enough money')
      else
        Success(input)
      end
    end
  end
end
