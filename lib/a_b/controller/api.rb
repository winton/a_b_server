Application.class_eval do
  
  get '/boot.json' do
    content_type :json
    restrict
    {
      :user_token => Token.cached.first,
      :tests => ABTest.find(:all)
    }.to_json(
      :include => :variants,
      :only => [ :user_token, :tests, :variants, :name, :visits ]
    )
  end
  
  get '/increment.js' do
    return nil unless valid_token?
    increment :conversions
    increment :visits
    nil
  end
end