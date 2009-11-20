Application.class_eval do
  
  get '/boot.json' do
    content_type :json
    restrict
    {
      :user_token => Token.cached,
      :tests => ABTest.find(:all)
    }.to_json(
      :include => :variants,
      :only => [ :user_token, :tests, :variants, :name, :visitors ]
    )
  end
  
  get '/convert.js' do
    return nil unless valid_token?
    increment :conversions
  end
  
  get '/visit.js' do
    return nil unless valid_token?
    increment :visitors
  end
end