require "#{File.dirname(__FILE__)}/require"
Require.rakefile!

if defined?(ActiveWrapper)
  ActiveWrapper::Tasks.new(
    :base => File.dirname(__FILE__),
    :env => ENV['ENV']
  )
end
