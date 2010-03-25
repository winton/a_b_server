Application.class_eval do
  helpers do
    
    def restrict
      token = Token.find_by_token params[:token]
      redirect '/' unless token
    end
  end
end
