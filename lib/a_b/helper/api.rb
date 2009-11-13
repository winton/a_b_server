Application.class_eval do
  helpers do
    
    def valid_token?
      Digest::SHA256.hexdigest(params[:session_id] + Token.cached) == params[:token]
    end
  end
end