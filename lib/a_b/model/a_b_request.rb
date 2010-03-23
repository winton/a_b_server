class ABRequest < ActiveRecord::Base
  
  set_table_name :requests
  serialize :data
  
  class <<self
  
    def process!
      conditions, lock_id = take_lock
      return unless lock_id
      
      begin
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
            
            # Increment conversions, visits, and extras
            variants = {}
            
            %w(c v e).each do |type|
              request.data[type].each do |test_id, variant_id|
                if type == 'e'
                  variant_id, hash = test_id, variant_id
                end
                
                variant = variants[variant_id] || ABVariant.find(variant_id)
                next unless variant
                variants[variant_id] = variant
                
                case type
                when 'c' then
                  variant.increment :conversions
                when 'v' then
                  variant.increment :visits
                when 'e' then
                  variant.extras ||= {}
                  hash.each do |key, value|
                    variant.extras[key] ||= 0
                    variant.extras[key] += value ? 1 : -1
                  end
                end
              end
            end
            
            variants.each { |variant_id, variant| variant.save }
            
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
      connection.execute "LOCK TABLE locks LOW_PRIORITY WRITE, requests READ LOCAL"
      conditions = Lock.unlocked_conditions
      
      first = self.first(
        :select => :id,
        :conditions => conditions
      )
      last = self.last(
        :select => :id,
        :conditions => conditions
      )
      
      if first && last
        lock_id = Lock.take first.id, last.id
      else
        lock_id = nil
      end
      
      [ conditions, lock_id ]
    ensure
      connection.execute "UNLOCK TABLES"
    end
  end
end