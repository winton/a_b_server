class ABRequest < ActiveRecord::Base
  
  set_table_name :requests
  serialize :data
end