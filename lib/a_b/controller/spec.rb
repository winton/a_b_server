Application.class_eval do
  
  if environment == :development
    before do
      ABPlugin::Config.root self.class.root
      a_b
    end
    
    get '/spec' do
      restrict
      
      # Setup a/b tests
      ABRequest.delete_all
      ABTest.delete_all
      ABVariant.delete_all
      ABTest.create :name => 'Test', :variants => 'v1, v2, v3'
      
      haml :spec, :layout => false
    end
  end
end
