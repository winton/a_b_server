class User < ActiveRecord::Base
  
  set_table_name :a_b_users
  acts_as_authentic
  
  def self.quick_create(u, p)
    self.create :login => u, :password => p, :password_confirmation => p
  end
end