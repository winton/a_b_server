Application.class_eval do
  helpers do
    
    def increment(attribute)
      return unless params[attribute]
      ABVariant.find_all_by_name(params[attribute]).each do |variant|
        variant.increment! attribute
      end
    end
    
    def valid_token?
      Token.cached.map { |token|
        Digest::SHA256.hexdigest(params[:session_id] + token) == params[:token]
      }.any?
    end
  end
end