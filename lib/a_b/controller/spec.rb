Application.class_eval do
  
  if environment == :development
    before do
      ABPlugin::Config.root self.class.root
      a_b
    end
    
    get '/spec' do
      restrict
      
      # Setup a/b tests
      ABTest.delete_all
      ABVariant.delete_all
      ABTest.create :name => 'Test', :variants => 'v1, v2, v3'
      ABTest.create :name => 'Test 2', :variants => 'v4, v5, v6'
      
      haml :spec, :layout => false
    end
    
    get '/spec/visit' do
      { :result => a_b(:test).visit,
        :tests => ABPlugin.tests
      }.to_json
    end
    
    get '/spec/convert' do
      a_b(:test).visit
      { :result => a_b(:test).convert,
        :tests => ABPlugin.tests
      }.to_json
    end
    
    get '/spec/conversions' do
      ABVariant.find_by_name(params[:variant]).conversions.to_s
    end
    
    get '/spec/visits' do
      ABVariant.find_by_name(params[:variant]).visits.to_s
    end
  end
end
