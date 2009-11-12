require 'rubygems'

gems = [
  [ 'active_wrapper', '=0.2.1' ],
  [ 'authlogic', '=2.1.3' ]
]

gems.each do |name, version|
  begin
    gem name, version
  rescue Exception
    $:.unshift "#{File.dirname(__FILE__)}/../vendor/#{name}/lib"
  end
end

require 'authlogic'
require 'active_wrapper'

$root = File.expand_path("#{File.dirname(__FILE__)}/../")

$db, $log, $mail = ActiveWrapper.setup(
  :base => $root,
  :env => 'development',
  :stdout => false
)
$db.establish_connection

Dir["#{$root}/lib/a_b/model/*.rb"].each do |path|
  require path
end