class IP < ActiveRecord::Base
  
  LIMIT_PER_DAY = 100
  set_table_name :ips
end