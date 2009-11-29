require 'rubygems'

gems = [
  [ 'haml', '=2.2.14' ],
  [ 'sinatra', '=0.9.4' ],
  [ 'active_wrapper', '=0.2.2' ],
  [ 'rack-flash', '=0.1.1' ],
  [ 'authlogic', '=2.1.3' ],
  [ 'rack_hoptoad', '=0.0.4' ]
]

gems.each do |name, version|
  if File.exists?(path = "#{File.dirname(__FILE__)}/../vendor/#{name}/lib")
    $:.unshift path
  else
    gem name, version
  end
end

require 'haml'
require 'sass'
require 'sinatra/base'
require 'active_wrapper'
require 'rack-flash'
require 'authlogic'
require 'rack_hoptoad'

class Application < Sinatra::Base
end

Dir["#{File.dirname(__FILE__)}/a_b/**/*.rb"].sort.each do |path|
  require path
end
