Application.class_eval do
  
  get '/' do
    restrict
    @css = @js = %w(index)
    @error = flash[:error]
    @success = flash[:success]
    puts 'a'
    @tests = ABTest.find :all, :order => 'updated_at desc'
    puts 'b'
    haml :index, :layout => :layout
  end
  
  get '/css/index.css' do
    headers 'Content-Type' => 'text/css; charset=utf-8'
    sass :index
  end
end
