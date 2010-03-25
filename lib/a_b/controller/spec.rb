Application.class_eval do
  
  if environment == :development
    before do
      ABPlugin::Config.root self.class.root
    end
    
    get '/spec' do
      haml :spec, :layout => false
    end
  end
end
