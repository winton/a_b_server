class User < ActiveRecord::Base
  
  has_many :tests, :class_name => 'ABTest', :foreign_key => 'test_id', :dependent => :delete_all
  has_many :variants, :through => :tests
end