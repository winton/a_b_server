Application.class_eval do
  
  get '/css/index.css' do
    headers 'Content-Type' => 'text/css; charset=utf-8'
    sass :index
  end
end