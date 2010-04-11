Application.class_eval do
  helpers do
    
    def allow_admin?
      user = User.find_by_token params[:token]
      user if user.admin?
    end
    
    def allow?(test=nil)
      user = User.find_by_token params[:token]
      user if user && (test.nil? || user.tests.include?(test))
    end
  end
end
