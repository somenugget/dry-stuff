require 'dry/transaction'

class SimpleTransaction
  include Dry::Transaction

  step :fetch
  step :get_names

  private

  def fetch
    if rand(2).zero?
      Success([{ name: 'erd' }, { name: 'wow' }])
    else
      Failure('Cannot fetch repositories')
    end
  end

  def get_names(repositories)
    if rand(2).zero?
      Success(repositories.map { |r| r[:name] })
    else
      Failure('Cannot convert names')
    end
  end
end
