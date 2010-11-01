class Category < ActiveRecord::Base
  
  belongs_to :site
  belongs_to :user
  
  has_many :tests, :class_name => 'ABTest', :dependent => :destroy
  has_many :variants
  
  validates_uniqueness_of :name, :scope => :site_id
end