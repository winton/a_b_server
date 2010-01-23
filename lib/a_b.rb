# Require gems and vendored libraries
boot = %w(require)

# Create Application class
boot += %w(application)

# Sinatra settings
boot += %w(sinatra)

# Rack::Session
boot += %w(session)

# Rack::Flash
boot += %w(flash)

# ActiveWrapper (database, logging, and email)
boot += %w(active_wrapper)

# Lilypad (Hoptoad notification)
boot += %w(lilypad)

# Controllers, helpers, and models
boot += %w(controller helper model)

boot.each do |file|
  require "#{File.dirname(__FILE__)}/a_b/boot/#{file}"
end