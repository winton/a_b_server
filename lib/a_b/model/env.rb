class Env < ActiveRecord::Base
  
  belongs_to :site
  belongs_to :user
  
  def self.names_by_user_id(user_id)
    self.find(:all, :conditions => { :user_id => user_id }).collect(&:name)
  end
end