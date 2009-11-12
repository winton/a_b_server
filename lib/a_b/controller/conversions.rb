Application.class_eval do
  
  get '/visit.js' do
    if valid_token? && variants = ABVariant.find_all_by_name(params[:variants])
      variants.each do |variant|
        variant.increment!(:visitors)
      end
    end
    redirect '/js/visit.js'
  end
  
  get '/convert.js' do
    if valid_token? && variant = ABVariant.find_by_name(params[:variant])
      variant.increment(:conversions)
      variant.increment(:visitors)
      variant.save
    end
  end
end