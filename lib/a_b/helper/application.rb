Application.class_eval do
  helpers do
    
    def allow_admin?
      user = User.find_by_token params[:token]
      user if user && user.admin?
    end
    
    def allow?(test=nil)
      user = User.find_by_token params[:token]
      user if user && (test.nil? || user.tests.include?(test))
    end
    
    def symbolize(array)
      array.collect! { |k| k.intern } if array && !array.blank?
    end
  end
end
