class IP < ActiveRecord::Base
  
  LIMIT_PER_DAY = 100
  set_table_name :ips
  
  before_save :set_date
  
  def self.create_or_increment(ip, date=Date.today)
    existing = self.find_by_ip_and_date(ip, date)
    if existing
      existing.increment!(:count)
      existing
    else
      self.create(:count => 1, :date => date, :ip => ip)
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