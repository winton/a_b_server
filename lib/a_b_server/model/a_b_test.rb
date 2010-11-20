class ABTest < ActiveRecord::Base
  
  set_table_name :tests
  
  belongs_to :category
  belongs_to :site
  belongs_to :user
  
  has_many :variants, :foreign_key => 'test_id', :dependent => :destroy
  
  validates_uniqueness_of :name, :scope => :category_id
  
  def control
    @control ||= self.variants.find_by_control true
  end
  
  def sorted_variants
    self.variants.find(:all, :order => 'control desc, conversions / visits desc, visits desc')
  end
end