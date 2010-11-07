class Env < ActiveRecord::Base
  
  belongs_to :site
  belongs_to :user
  
  validates_uniqueness_of :name, :scope => :site_id
  
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