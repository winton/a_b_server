class IP < ActiveRecord::Base
  
  LIMIT_PER_DAY = 100
  set_table_name :ips
  
  before_save :set_date
  
  def self.create_or_increment(ip)
    existing = self.find_by_ip_and_date(ip, Date.today)
    if existing
      existing.increment!(:count)
      existing
    else
      self.create(:ip => ip, :count => 1)
    end
  end
  
  def limited?
    self.count > LIMIT_PER_DAY
  end
  
  private
  
  def set_date
    self.date = Date.today if self.date.nil?
  end
end