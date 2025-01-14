require 'sidekiq'
require "sidekiq/throttled"
require "sidekiq/throttled/web"

Sidekiq.configure_server do |config|
  database_url = ENV['DATABASE_URL']

  if database_url
    pool_size = Sidekiq.options[:concurrency] # one example of what this could be...
    ENV['DATABASE_URL'] = "#{database_url}?pool=#{pool_size}" # only affects this process
    ActiveRecord::Base.establish_connection
  end
end
