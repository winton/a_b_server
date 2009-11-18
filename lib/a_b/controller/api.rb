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
    if variant = ABVariant.find_by_name(params[:variant])
      variant.increment!(:conversions)
    end
    'true'
  end
  
  get '/visit.js' do
    return nil unless valid_token?
    if params[:variants] && variants = ABVariant.find_all_by_name(params[:variants])
      variants.each do |variant|
        variant.increment!(:visitors)
      end
    end
    redirect '/js/visit.js'
  end
end