class User < ActiveRecord::Base
  
  has_many :categories, :dependent => :destroy
  has_many :variants, :through => :tests
end