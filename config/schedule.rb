set :environment, ENV['ENV'] || ENV['RACK_ENV']
set :output, { :error => 'cron_error.log', :standard => 'cron.log' }

every 1.day do
  rake "cron:every_day"
end