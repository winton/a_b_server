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
    
    def symbolize(object)
      return unless object && !object.blank?
      if object == 'true'
        {}
      elsif object.respond_to?(:intern)
        object.intern
      elsif object.respond_to?(:keys)
        object.to_a.inject({}) do |hash, (key, value)|
          hash[symbolize(key)] = symbolize(value)
          hash
        end
      elsif object.respond_to?(:index)
        object.collect! { |a| symbolize(a) }
      else
        object
      end
    end
  end
end