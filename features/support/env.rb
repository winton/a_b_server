$testing = true
$root = File.expand_path(File.dirname(__FILE__) + "/../../")
$:.unshift "#{$root}/lib"

require 'a_b'

gems = [
  [ 'rack-test', '=0.5.1' ],
  [ 'rspec', '=1.2.9' ],
  [ 'webrat', '=0.5.3' ]
]

gems.each do |name, version|
  if File.exists?(path = "#{File.dirname(__FILE__)}/../../vendor/#{name}/lib")
    $:.unshift path
  else
    gem name, version
  end
end

require 'rack/test'
require 'spec/mocks'
require 'test/unit'
require 'webrat'

Before do
  $db.migrate_reset
end

World do
  def app
    Application
  end
  
  include Rack::Test::Methods
  include Test::Unit::Assertions
  include Webrat::Matchers
  include Webrat::Methods
end
