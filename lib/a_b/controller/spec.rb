Application.class_eval do
  
  if environment == :development
    before do
      ABPlugin::Config.root self.class.root
    end
    
    get '/spec' do
      ABVariant.delete(2)
      ABVariant.connection.insert("INSERT INTO variants (id, name) VALUES (2, 'test')")
      haml :spec, :layout => false
    end
  end
end
