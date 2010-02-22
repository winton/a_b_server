Application.class_eval do
  
  if environment == :development
    get '/spec' do
      restrict
      
      # Setup a/b tests
      ABTest.delete_all
      ABVariant.delete_all
      ABTest.create :name => 'Test', :variants => 'v1, v2, v3'
      ABTest.create :name => 'Test 2', :variants => 'v4, v5, v6'
      
      # ABPlugin config
      ABPlugin::Config.root self.class.root
      
      # Controller tests
      a_b(:test).visit
      a_b(:test).convert
      a_b(:test).visit do |variant|
        @visit_test = (variant == 'v1')
      end
      a_b(:test).convert do |variant|
        @convert_test = (variant == 'v1')
      end
      
      #haml :spec, :layout => false
      nil
    end
    
    get '/spec/conversions' do
      ABVariant.find_by_name(params[:variant]).conversions.to_s
    end
    
    get '/spec/visits' do
      ABVariant.find_by_name(params[:variant]).visits.to_s
    end
  end
end
