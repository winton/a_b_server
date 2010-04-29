class Site < ActiveRecord::Base
  
  belongs_to :user
  
  has_many :categories, :dependent => :destroy
  has_many :collaborations
  has_many :collab_users, :class_name => 'User', :source => :user, :through => :collaborations
  has_many :envs, :dependent => :delete_all
  has_many :tests, :class_name => 'ABTest'
  has_many :variants
end