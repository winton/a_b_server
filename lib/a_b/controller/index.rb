Application.class_eval do
  
  get '/' do
    @error = flash[:error]
    @success = flash[:success]
    @tests = ABTest.find :all, :order => 'updated_at'
    haml :index, :layout => :layout
  end
  
  get '/css/index.css' do
    headers 'Content-Type' => 'text/css; charset=utf-8'
    sass :index
  end
end
