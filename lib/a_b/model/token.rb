class Token < ActiveRecord::Base
  
  set_table_name :a_b_tokens
  @@cached_at = nil
  
  def self.cached
    if @@cached_at.nil? || @@cached_at < Time.now.utc - 60 * 60
      @@cached = Token.find(:all, :limit => 2, :order => 'id desc')
      if @@cached.empty? || @@cached.first.created_at < Time.now.utc - 60 * 60
        @@cached.pop
        @@cached << generate
      end
      @@cached_at = @@cached.first.created_at
      @@cached = @@cached.collect &:token
    end
    @@cached
  end
  
  private
  
  def self.generate
    self.create :token => Authlogic::Random.friendly_token
  end
end