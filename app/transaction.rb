require './lib/user_repositories'

result = UserRepositories.new.call

if result.success?
  puts result.success
else
  puts "Error: #{result.failure}"
end

UserRepositories.new.call do |result|
  result.success do |names|
    puts names
  end

  result.failure :fetch do |error|
    puts "HTTP error: #{error}"
  end

  result.failure :get_names do |error|
    puts "Data error: #{error}"
  end
end
