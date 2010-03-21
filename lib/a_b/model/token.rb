class Token < ActiveRecord::Base
  
  def before_create
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    self.token = (1..20).collect { |i| chars[rand(chars.size-1)] }.join
  end
end