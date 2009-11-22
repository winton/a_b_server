Application.class_eval do
  helpers do
    
    def increment(attribute)
      if params[:variants] && variants = ABVariant.find_all_by_name(params[:variants])
        variants.each do |variant|
          variant.increment! attribute
        end
      end
      nil
    end
    
    def valid_token?
      valid = false
      Token.cached.each do |token|
        valid = Digest::SHA256.hexdigest(params[:session_id] + token) == params[:token]
        break if valid
      end
      valid
    end
  end
end