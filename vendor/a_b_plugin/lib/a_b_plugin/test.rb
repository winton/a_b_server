class ABPlugin
  class Test
    
    def initialize(c, t=nil, e=nil, &block)
      # c, t, e = category, test, extras
      
      if c.respond_to?(:keys)
        e, c = c, nil
      end
      
      @data = Datastore.new
      @extras = @data.get(:e)
      @extras.merge!(e) if e
      
      if c && t
        @category = category(c)
        @test = test(t)
      else
        @data.set(:e, @extras)
      end
      
      yield(self) if block_given?
    end
    
    def convert(name=nil, &block)
      return unless @test
      
      conversion = variant(@data.get(:c))
      visit = variant(@data.get(:v))
      variant = variant(name)
      visited = true
      
      unless visit
        visit = variant
        visited = false
      end
      
      unless conversion
        conversion = visit
      end
      
      if conversion && (!name || conversion == variant)
        @data.set(:c, conversion['id'], @extras)
        @data.set(:v, conversion['id'], @extras) unless visited
        
        if block_given?
          block.call(symbolize_name(conversion['name']))
        end
        
        symbolize_name(conversion['name'])
      end
    end
    
    def visit(name=nil, &block)
      return unless @test
      
      visit = variant(@data.get(:v))
      variant = variant(name)
      
      if !visit && !@test['variants'].empty?
        if $testing
          visit = @test['variants'][0]
        else
          visit = @test['variants'][rand(@test['variants'].size)]
        end
      end
      
      if visit && (!name || visit == variant)
        @data.set(:v, visit['id'], @extras)
        
        if block_given?
          block.call symbolize_name(visit['name'])
        end
        
        symbolize_name(visit['name'])
      end
    end
    
    private
    
    def category(name)
      ABPlugin.categories.detect do |c|
        c['name'] == name ||
        symbolize_name(c['name']) == name
      end
    end
    
    def symbolize_name(name)
      name.downcase.gsub(/[^a-zA-Z0-9\s]/, '').gsub(/\s+/, '_').intern
    end
    
    def test(name)
      return unless @category
      @category['tests'].detect do |t|
        t['name'] == name ||
        symbolize_name(t['name']) == name
      end
    end
    
    def variant(ids_or_name)
      return unless ids_or_name && @test
      @test['variants'].detect do |v|
        if ids_or_name.respond_to?(:flatten)
          ids_or_name.detect { |id| id == v['id'] }
        else
          v['name'] == ids_or_name ||
          symbolize_name(v['name']) == ids_or_name
        end
      end
    end
  end
end