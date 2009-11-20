require 'rubygems'

gems = [
  [ 'active_wrapper', '=0.2.1' ],
  [ 'authlogic', '=2.1.3' ]
]

gems.each do |name, version|
  if File.exists?(path = "#{File.dirname(__FILE__)}/../vendor/#{name}/lib")
    $:.unshift path
  else
    gem name, version
  end
end

require 'authlogic'
require 'active_wrapper'

$root = File.expand_path("#{File.dirname(__FILE__)}/../")

$db, $log, $mail = ActiveWrapper.setup(
  :base => $root,
  :env => ENV['ENV'],
  :stdout => false
)
$db.establish_connection

Dir["#{$root}/lib/a_b/model/*.rb"].each do |path|
  require path
end