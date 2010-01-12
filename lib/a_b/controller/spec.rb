Application.class_eval do
  
  get '/spec' do
    restrict
    haml :spec, :layout => false
  end
end
