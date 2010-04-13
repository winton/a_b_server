class ABPlugin
  class Datastore
    
    def initialize
      # Get cookie
      @data = Cookies.get('a_b')
      @send = Cookies.get('a_b_s')
      # Convert from JSON
      @data = JSON(@data || '{}')
      @send = JSON(@send || '{}')
      # Symbolize keys
      @data = symbolize_keys(@data)
      @send = symbolize_keys(@send)
    end
    
    def get(key)
      @data[key] || (key == :e ? {} : [])
    end
    
    def set(key, value, extras=nil)
      return unless value
      @data[key] ||= []
      # Store current version for later comparison
      old = @data[key].dup
      # Hash
      if value.respond_to?(:keys)
        @data[key] = value
      # Array
      elsif value.respond_to?(:flatten)
        @data[key] += value
      # Other value
      else
        @data[key] << value
      end
      @data[key].uniq!
      unless key == :e
        # Add difference to @send
        diff = @data[key] - old
        unless diff.empty?
          @send[key] ||= []
          @send[key] += diff
          @send[key].uniq!
          @send[:e] = extras unless extras.empty?
        end
      end
      # Export data to cookies
      to_cookies
    end
    
    private
    
    def symbolize_keys(hash)
      hash.inject({}) do |options, (key, value)|
        options[(key.to_sym rescue key) || key] = value
        options
      end
    end
    
    def to_cookies
      Cookies.set('a_b', @data.to_json) unless @data.empty?
      Cookies.set('a_b_s', @send.to_json) unless @send.empty?
    end
  end
end