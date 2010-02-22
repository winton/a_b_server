Application.class_eval do
  
  if environment == :development
    get '/spec2' do
      restrict
      
      # Setup a/b tests
      ABTest.delete_all
      ABVariant.delete_all
      ABTest.create :name => 'Test', :variants => 'v1, v2, v3'
      ABTest.create :name => 'Test 2', :variants => 'v4, v5, v6'
      
      # ABPlugin config
      ABPlugin::Config.root self.class.root
      
      # Controller tests
      a_b_visit('Test')
      a_b_convert('Test')
      a_b_visit('Test') do |test, variant|
        @visit_test = (test == 'Test' && variant == 'v1')
      end
      a_b_convert('Test') do |test, variant|
        @convert_test = (test == 'Test' && variant == 'v1')
      end
      
      haml :spec, :layout => false
    end
    
    get '/spec2/conversions' do
      ABVariant.find_by_name(params[:variant]).conversions.to_s
    end
    
    get '/spec2/visits' do
      ABVariant.find_by_name(params[:variant]).visits.to_s
    end
  end
end
