require 'json'
require 'net/http'
require 'dry/transaction/operation'

module Blog
  class Get
    include Dry::Transaction::Operation

    def call(endpoint:)
      response = Net::HTTP.get(
        'jsonplaceholder.typicode.com',
        "/#{endpoint}"
      )

      Success(JSON.parse(response))
    end
  end
end
