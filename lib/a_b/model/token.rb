class Token < ActiveRecord::Base
  
  set_table_name :a_b_tokens
  @@cached_at = nil
  
  class <<self
    def cached
      if @@cached_at.nil? || (Time.now.utc - @@cached_at).to_i >= 60
        @@cached = Token.find(:all, :limit => 2, :order => 'id desc')
        if @@cached.empty? || (Time.now.utc - @@cached.first.created_at).to_i >= 60 * 60
          @@cached.pop if @@cached.length > 1
          @@cached.unshift generate
        end
        @@cached_at = Time.now.utc
        @@cached = @@cached.collect &:token
      end
      @@cached
    end
  
    private
  
    def generate
      self.create :token => Authlogic::Random.friendly_token
    end
    
    def reset
      @@cached_at = nil
    end
  end
end