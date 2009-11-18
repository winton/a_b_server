class Token < ActiveRecord::Base
  
  set_table_name :a_b_tokens
  @@cached_at = nil
  
  def self.cached
    if @@cached_at.nil? || @@cached_at < Time.now.utc - 60
      @@cached = self.last.token
      @@cached_at = Time.now.utc
    end
    @@cached
  end
  
  def self.generate!
    if !self.last or (self.last.created_at < Time.now.utc - 60 * 60)
      token = self.create(:token => Authlogic::Random.friendly_token).token
    else
      token = self.last.token
    end
    token
  end
end