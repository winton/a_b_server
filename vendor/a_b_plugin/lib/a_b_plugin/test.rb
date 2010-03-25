class ABPlugin
  class Test
    
    def initialize(test)
      @test = ABPlugin.tests.detect do |t|
        t['name'] == test || symbolize_name(t['name']) == test
      end
    end
    
    def convert(name=nil, extra=nil, &block)
      return unless @test
      
      if name.respond_to?(:keys)
        extra = name
        name = nil
      end
      
      conversion = variant(Cookies.get(:conversions, @test))
      visit = variant(Cookies.get(:visits, @test))
      variant = variant(name)
      
      unless visit
        visit = variant
      end
      
      unless conversion
        conversion = visit
      end
      
      if conversion && (!name || conversion == variant)
        Cookies.set(:conversions, @test, conversion, extra)
        Cookies.set(:visits, @test, conversion, extra)
        
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
      
      visit = variant(Cookies.get(:visits, @test))
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
        Cookies.set(:visits, @test, visit, extra)
        
        if block_given?
          block.call symbolize_name(visit['name'])
        end
        
        symbolize_name(visit['name'])
      end
    end
    
    private
    
    def symbolize_name(name)
      name.downcase.gsub(/[^a-zA-Z0-9\s]/, '').gsub('_', '').intern
    end
    
    def variant(id_or_name)
      return unless id_or_name && @test
      @test['variants'].detect do |v|
        v['id'] == id_or_name ||
        v['name'] == id_or_name ||
        symbolize_name(v['name']) == id_or_name
      end
    end
  end
end