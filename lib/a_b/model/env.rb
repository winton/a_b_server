class Env < ActiveRecord::Base
  
  belongs_to :site
  belongs_to :user
  
  def domain_match?(referer)
    match =
      begin
        domains.split(',').detect do |domain|
          r = referer.match(/:\/\/([^:\/]+)/)[1]
          r[(-1*domain.length)..-1] == domain
        end
      rescue Exception => e
        nil
      end
    !match.nil?
  end
end