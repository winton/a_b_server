Application.class_eval do
  
  if environment == :development
    get '/spec' do
      restrict
      
      # Setup a/b tests
      ABTest.delete_all
      ABVariant.delete_all
      ABTest.create :name => 'Test', :variants => 'v1, v2, v3'
      ABTest.create :name => 'Test2', :variants => 'v4, v5, v6'
      
      # ABPlugin config
      ABPlugin.tests = JSON ABTest.find(:all).to_json(
        :include => :variants,
        :only => [ :tests, :variants, :name, :visits ]
      )
      ABPlugin.url = 'http://127.0.0.1:9393'
      ABPlugin.user_token = Token.cached.first
      
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
    
    get '/spec/conversions' do
      ABVariant.find_by_name(params[:variant]).conversions.to_s
    end
    
    get '/spec/visits' do
      ABVariant.find_by_name(params[:variant]).visits.to_s
    end
  end
end
