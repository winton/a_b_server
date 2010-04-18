class User < ActiveRecord::Base
  
  has_many :categories, :dependent => :destroy
  has_many :envs, :dependent => :delete_all
  has_many :tests, :class_name => 'ABTest'
  has_many :variants
end