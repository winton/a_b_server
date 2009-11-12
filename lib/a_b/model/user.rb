class User < ActiveRecord::Base
  
  set_table_name :a_b_users
  acts_as_authentic
end