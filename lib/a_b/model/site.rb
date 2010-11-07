class Site < ActiveRecord::Base
  
  belongs_to :user
  
  has_many :categories, :dependent => :destroy
  has_many :envs, :dependent => :delete_all
  has_many :tests, :class_name => 'ABTest'
  has_many :variants
  
  validates_uniqueness_of :name, :scope => :user_id
end