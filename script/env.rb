require 'rubygems'
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