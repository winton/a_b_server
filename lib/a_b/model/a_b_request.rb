class ABRequest < ActiveRecord::Base
  
  set_table_name :requests
  
  serialize :conversion_ids
  serialize :visit_ids
  
  def self.record(agent, identifier, ip, visits, conversions)
    r = ABRequest.find_or_initialize_by_identifier_and_ip(
      identifier, ip
    )
    r.agent = agent
    r.visits += visits.length
    r.conversions += conversions.length
    r.visit_ids ||= []
    r.conversion_ids ||= []
    r.found_duplicate ||= (
      (r.visit_ids & visits).length > 0 ||
      (r.conversion_ids & conversions).length > 0
    )
    r.visit_ids += visits
    r.conversion_ids += conversions
    r.save
    r
  end
end