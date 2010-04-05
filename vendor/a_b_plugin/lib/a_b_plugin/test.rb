class ABPlugin
  class Test
    
    def initialize(test)
      @data = Datastore.new
      @test = ABPlugin.tests.detect do |t|
        t['name'] == test ||
        symbolize_name(t['name']) == test
      end
    end
    
    def convert(name=nil, extra=nil, &block)
      return unless @test
      
      if name.respond_to?(:keys)
        extra = name
        name = nil
      end
      
      conversion = variant(@data.get(:c))
      visit = variant(@data.get(:v))
      variant = variant(name)
      
      unless visit
        visit = variant
      end
      
      unless conversion
        conversion = visit
      end
      
      if conversion && (!name || conversion == variant)
        @data.set(:c, conversion['id'])
        @data.set(:v, conversion['id'])
        @data.set("e#{conversion['id']}".intern, extra)
        
        if block_given?
          block.call(symbolize_name(conversion['name']))
        end
        
        symbolize_name(conversion['name'])
      end
    end
    
    def visit(name=nil, extra=nil, &block)
      return unless @test
      
      if name.respond_to?(:keys)
        extra = name
        name = nil
      end
      
      visit = variant(@data.get(:v))
      variant = variant(name)
      
      already_recorded = (visit && visit == variant) || (!name && visit)
      
      if !visit && !@test['variants'].empty?
        if @test['variants'][0]['visits']
          variants = @test['variants'].sort do |a, b|
            a['visits'] <=> b['visits']
          end
          visit = variants.first
        else
          visit = @test['variants'][rand(@test['variants'].size)]
        end
      end
      
      if visit && (!name || visit == variant)
        visit['visits'] += 1 unless already_recorded
        @data.set(:v, visit['id'])
        @data.set("e#{visit['id']}".intern, extra)
        
        if block_given?
          block.call symbolize_name(visit['name'])
        end
        
        symbolize_name(visit['name'])
      end
    end
    
    private
    
    def symbolize_name(name)
      name.downcase.gsub(/[^a-zA-Z0-9\s]/, '').gsub(/\s+/, '_').intern
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