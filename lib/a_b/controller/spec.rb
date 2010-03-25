Application.class_eval do
  
  if environment == :development
    before do
      ABPlugin::Config.root self.class.root
      a_b
    end
    
    get '/spec' do
      restrict
      haml :spec, :layout => false
    end
  end
end
