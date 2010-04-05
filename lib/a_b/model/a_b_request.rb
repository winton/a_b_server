class ABRequest < ActiveRecord::Base
  
  set_table_name :requests
  
  def self.record(identifier, ip, visits, conversions)
    request = ABRequest.find_or_create_by_identifier_and_ip(
      identifier, ip
    )
    request.visits += visits
    request.conversions += conversions
    request.save
  end
end