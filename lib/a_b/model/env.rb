class Env < ActiveRecord::Base
  
  extend CachedFind
  
  belongs_to :site
  belongs_to :user
  
  def domain_match?(referer)
    d = (domains || '').split(',')
    match =
      begin
        d.empty? ||
        d.detect do |domain|
          r = referer.match(/:\/\/([^:\/]+)/)[1]
          r[(-1*domain.length)..-1] == domain
        end
      rescue Exception => e
        nil
      end
    !match.nil? && match != false
  end
end