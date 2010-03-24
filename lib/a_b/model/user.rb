class User < ActiveRecord::Base
  
  has_many :tests, :class_name => 'ABTest', :foreign_key => 'user_id', :dependent => :destroy
  has_many :variants, :through => :tests
end