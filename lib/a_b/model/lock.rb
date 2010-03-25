class Lock < ActiveRecord::Base
  
  def before_create
    self.name = self.class.lock_name
  end
  
  class <<self
    
    def lock_name
      "host:#{Socket.gethostname} pid:#{Process.pid}" rescue "pid:#{Process.pid}"
    end
    
    def release(id, e=nil)
      lock = self.find id
      if e
        lock.update_attributes(
          :error => [ e.message, e.backtrace ].join("\n"),
          :failed_at => Time.now.utc
        )
      else
        lock.destroy
      end
    end
    
    def take(start_id, end_id)
      self.create(:start => start_id, :end => end_id).id
    end
    
    def unlocked_conditions
      unlocked = self.all(
        :conditions => { :failed_at => nil },
        :select => 'start, end'
      )
      conditions = unlocked.collect do |lock|
        if lock.start && lock.end
          "(id NOT BETWEEN #{lock.start} AND #{lock.end})"
        else
          nil
        end
      end
      conditions.compact.join ' AND '
    end
  end
end