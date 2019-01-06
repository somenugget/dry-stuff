require 'dry-struct'

require_relative '../types'

module Payments
  class Params < Dry::Struct
    attribute :recipient_id, Types::Strict::String.constrained(format: /\d+/)
    attribute :sum, Types::Coercible::Integer.constrained(gt: 0)
  end
end
