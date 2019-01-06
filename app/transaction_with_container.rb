require './lib/create_payment'
require './lib/payments/params'

require 'optparse'

options = {}

OptionParser.new do |parser|
  parser.on('-r', '--recipient RECIPIENT_ID') do |recipient_id|
    options[:recipient_id] = recipient_id
  end

  parser.on('-s', '--sum SUM') do |sum|
    options[:sum] = sum
  end
end.parse!

CreatePayment.new.call(Payments::Params.new(options)) do |result|
  result.success do |transaction|
    puts "Payment sent. Transaction id is #{transaction[:transaction_id]}"
  end

  result.failure :validate do |error|
    puts "Validation error: #{error}"
  end
end
