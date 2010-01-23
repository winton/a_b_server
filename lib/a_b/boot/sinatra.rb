Application.class_eval do
  
  set :environment, $testing ? :test : environment
  set :root, File.expand_path("#{File.dirname(__FILE__)}/../../../")
  set :public, "#{root}/public"
  set :logging, true
  set :static, true
  set :views, "#{root}/lib/a_b/view"
end