class IP < ActiveRecord::Base
  
  LIMIT_PER_DAY = 10
  set_table_name :ips
end