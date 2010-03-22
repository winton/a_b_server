class ABRequest < ActiveRecord::Base
  
  set_table_name :requests
  serialize :data
  
  class <<self
  
    def process!
      begin
        conditions, lock_id = take_lock
        counts_by_user_id = {}
        times_by_user_id = {}
        
        self.find_each(:conditions => conditions) do |request|
          # Get user
          test = request.data['c'] || request.data['v']
          test = ABTest.find variant.keys.first
          user = test.user if test
          
          # Skip if user not found
          next unless user
          
          # Clear count if more than a minute passed
          time = times_by_user_id[user.id]
          if time.nil? || request.created_at - time >= 60
            counts_by_user_id.delete user.id
            times_by_user_id.delete user.id
          end
          
          # If not over limit, execute
          if user.limit_per_minute.nil? || counts_by_user_id[user.id] < user.limit_per_minute
            # Update time and count
            counts_by_user_id[user.id] ||= 0
            counts_by_user_id[user.id] += 1
            times_by_user_id[user.id] = request.created_at
            
            # Increment conversions and visits
            request.data['c'].each do |test_id, variant_id|
              variant = ABVariant.find(variant_id)
              next unless variant
              variant.increment! :conversions
            end
            
            request.data['v'].each do |test_id, variant_id|
              variant = ABVariant.find(variant_id)
              next unless variant
              variant.increment! :visits
            end
            
            # Finish up
            request.update_attribute :processed, true
            request.destroy # acts_as_archive destroy
          else
            request.destroy # acts_as_archive destroy
          end
        end
        
        Lock.release lock_id
      rescue Exception => e
        Lock.release lock_id, e
        say "Lock #{lock_id} failed!"
      end
    end
  
    def say(text)
      $log.info "#{Time.now.strftime('%FT%T%z')}: #{text}"
    end
    
    def take_lock
      connection.execute "LOCK TABLE locks LOW_PRIORITY WRITE"
      conditions = Lock.exclude_conditions
      first_id = self.first(
        :select => :id,
        :conditions => conditions
      )
      last_id = self.last(
        :select => :id,
        :conditions => conditions
      )
      lock = Lock.take first_id, last_id
      [ conditions, lock.id ]
    ensure
      connection.execute "UNLOCK TABLES"
    end
  end
end