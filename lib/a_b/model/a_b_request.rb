class ABRequest < ActiveRecord::Base
  
  set_table_name :requests
  
  acts_as_archive
  serialize :data
  
  class <<self
    
    def increment(request)
      @variants ||= {}
      
      %w(c v e).each do |type|
        (request.data[type] || {}).each do |test_id, variant_id|
          if type == 'e'
            variant_id, hash = test_id, variant_id
          end
          
          variant = @variants[variant_id] || ABVariant.find_by_id(variant_id)
          next unless variant
          @variants[variant_id] = variant
          
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
      
      @variants.each { |variant_id, variant| variant.save }
    end
    
    def limit_ip(request)
      date = request.created_at.strftime('%Y/%m/%d')
      
      @ips ||= {}
      @ips[date] ||= {}
      
      ip = @ips[date][request.ip] || IP.find_or_create_by_ip(
        request.ip,
        :conditions => [ "date = ?", Date.parse(date) ]
      )
      
      @ips[date][request.ip] = ip
      
      unless ip.date
        ip.date = Date.parse(date)
      end
      
      ip.count += request.count
      ip.save
      
      (ip.count - 1) >= IP::LIMIT_PER_DAY
    end
  
    def process!
      reset
      conditions, lock_id = take_lock
      return unless lock_id
      
      begin
        self.find_each(:conditions => conditions) do |request|
          unless limit_ip(request)
            next unless user = user(request)
            increment(request)
            request.update_attribute :processed, true
          end
          request.destroy # acts_as_archive destroy
        end
        
        Lock.release lock_id
        
      rescue Exception => e
        Lock.release lock_id, e
        say "Lock #{lock_id} failed!"
      end
    end
    
    def reset
      @ips = nil
      @variants = nil
    end
  
    def say(text)
      $log.info "#{Time.now.strftime('%FT%T%z')}: #{text}\n\n"
    end
    
    def take_lock
      # Doing this weird two-run thing so we only take locks when necessary
      2.times do |iteration|
        begin
          if iteration == 1
            connection.execute "LOCK TABLE locks LOW_PRIORITY WRITE, requests READ LOCAL"
          end
          
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
            next if iteration == 0
            lock_id = Lock.take first.id, last.id
          else
            lock_id = nil
          end
      
          return [ conditions, lock_id ]
        ensure
          if iteration == 1
            connection.execute "UNLOCK TABLES"
          end
        end
      end
    end
    
    def user(request)
      test = request.data['c'] || request.data['v']
      test = ABTest.find_by_id test.keys.first
      if test
        test.user
      else
        nil
      end
    end
  end
end