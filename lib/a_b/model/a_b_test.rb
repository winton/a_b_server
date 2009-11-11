class ABTest < ActiveRecord::Base
  
  set_table_name :a_b_tests
  has_many :variants, :class_name => 'ABVariant', :foreign_key => 'a_b_test_id', :dependent => :destroy
  
  validates_uniqueness_of :name
  
  after_save :destroy_variants
  after_save :create_variants
  after_save :set_control
  
  def variants=(names)
    names = names.split(',').collect(&:strip).uniq
    current_names = variants.collect(&:name).collect(&:strip).uniq
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
    if control = self.variants.find_by_control(true)
      control.update_attribute(:control, false)
    end
    if name = self.variants.find_by_name(@control)
      name.update_attribute(:control, true)
    elsif !self.variants.empty?
      self.variants.first.update_attribute(:control, true)
    end
  end
end