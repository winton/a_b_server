class User < ActiveRecord::Base
  
  has_many :categories
  has_many :collaborations
  has_many :collab_sites, :class_name => 'Site', :source => :site, :through => :collaborations
  has_many :envs
  has_many :sites, :dependent => :destroy
  has_many :tests, :class_name => 'ABTest'
  has_many :variants
  
  def before_create
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    self.token ||= (1..20).collect { |i| chars[rand(chars.size-1)] }.join
  end
end