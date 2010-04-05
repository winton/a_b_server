class IP < ActiveRecord::Base
  
  LIMIT_PER_DAY = 100
  set_table_name :ips
  
  def self.create_or_increment(ip)
    existing = self.find_by_ip_and_date(ip, Date.today)
    if existing
      existing.increment!(:count)
      existing
    else
      self.create(:ip => ip, :date => Date.today, :count => 1)
    end
  end
  
  def limited?
    self.count > LIMIT_PER_DAY
  end
end