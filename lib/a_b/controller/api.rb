Application.class_eval do
  
  get '/boot.json' do
    restrict
    {
      :user_token => Token.cached,
      :tests => ABTest.find(:all)
    }.to_json(
      :include => :variants,
      :only => [ :name, :visitors ]
    )
  end
  
  get '/convert.js' do
    if valid_token? && variant = ABVariant.find_by_name(params[:variant])
      variant.increment(:conversions)
      variant.increment(:visitors)
      variant.save
    end
  end
  
  get '/visit.js' do
    if valid_token? && variants = ABVariant.find_all_by_name(params[:variants])
      variants.each do |variant|
        variant.increment!(:visitors)
      end
    end
    redirect '/js/visit.js'
  end
end