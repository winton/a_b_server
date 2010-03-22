class ABTest < ActiveRecord::Base
  
  set_table_name :tests
  
  after_save :destroy_variants
  after_save :create_variants
  after_save :set_control
  
  belongs_to :user
  
  has_many :variants, :class_name => 'ABVariant', :foreign_key => 'test_id', :dependent => :delete_all
  
  validates_uniqueness_of :name
  
  def control
    self.variants.find_by_control true
  end
  
  def sorted_variants
    self.variants.find(:all, :order => 'control desc, conversions / visits desc, visits desc')
  end
  
  def variant_names
    names = self.variants.collect &:name
    names.delete self.control.name
    names.unshift self.control.name
  end
  
  def variants=(names)
    names = names.split(',').collect(&:strip).uniq
    current_names = variants.collect(&:name).uniq
    @control = names.first
    @new_variant_names = names - current_names
    @removed_variant_names = current_names - names
  end
  
  private
  
  def create_variants
    return unless @new_variant_names
    @new_variant_names.each do |name|
      self.variants.create(:name => name)
    end
  end
  
  def destroy_variants
    return unless @removed_variant_names
    remove = self.variants.find(:all, :conditions => { :name => @removed_variant_names })
    remove.each do |variant|
      variant.destroy
    end
  end
  
  def set_control
    if @control
      if self.control
        self.control.update_attribute(:control, false)
      end
      if name = self.variants.find_by_name(@control)
        name.update_attribute(:control, true)
      elsif !self.variants.empty?
        self.variants.first.update_attribute(:control, true)
      end
    elsif !self.control && !self.variants.empty?
      self.variants.first.update_attribute(:control, true)
    end
  end
end
