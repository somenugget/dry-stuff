require 'dry/transaction/operation'

module Payments
  class Pay
    include Dry::Transaction::Operation

    def call(input)
      Success(transaction_id: rand(9999).to_s)
    end
  end
end
