class User < ActiveRecord::Base
  
  has_many :categories
  has_many :envs
  has_many :sites, :dependent => :destroy
  has_many :tests, :class_name => 'ABTest'
  has_many :variants
end