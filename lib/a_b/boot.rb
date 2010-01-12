Application.class_eval do
  
  # Sinatra
  enable :raise_errors
  disable :logging, :show_exceptions
  set :environment, $testing ? :test : environment
  set :root, File.expand_path("#{File.dirname(__FILE__)}/../../")
  set :public, "#{root}/public"
  set :static, true
  set :views, "#{root}/lib/a_b/view"
    
  # Database, logging, and email
  $db, $log, $mail = ActiveWrapper.setup(
    :base => root,
    :env => environment,
    :stdout => environment != :test
  )
  $db.establish_connection
  if $mail.config
    ActionMailer::Base.raise_delivery_errors = true
  end
  
  # Rack session
  use Rack::Session::Cookie
  
  # Rack flash
  use Rack::Flash, :accessorize => %w(error notice success)
  
  # Hoptoad notifier
  if File.exists?(hoptoad = "#{root}/config/hoptoad.txt")
    use Rack::Lilypad, File.read(hoptoad).strip
  end
  
  # Require controllers, helpers, and models
  %w(controller helper model).each do |dir|
    Dir["#{File.dirname(__FILE__)}/#{dir}/*.rb"].sort.each do |path|
      require path
    end
  end

  # ABPlugin config for spec controller
  if User.first
    ABPlugin.cached_at = Time.now
    ABPlugin.tests = JSON ABTest.find(:all).to_json(
      :include => :variants,
      :only => [ :tests, :variants, :name, :visits ]
    )
    ABPlugin.token = User.first.persistence_token
    ABPlugin.url = 'http://127.0.0.1:3000'
    ABPlugin.user_token = Token.cached.first
  end
end
