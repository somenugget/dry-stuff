require 'dry/monads/result'
require './lib/simple_transaction'

fetch = ->(_input) { Dry::Monads.Success([]) }

result = SimpleTransaction.new(fetch: fetch).call

p result
