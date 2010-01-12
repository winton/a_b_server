class User < ActiveRecord::Base
  
  set_table_name :a_b_users
  acts_as_authentic
  
  def self.quick_create(u, p)
    user = self.create(:login => u, :password => p, :password_confirmation => p)
    puts "\nCouldn't save user:\n#{user.errors.to_a.inspect}\n\n" unless user.id
    user
  end
end