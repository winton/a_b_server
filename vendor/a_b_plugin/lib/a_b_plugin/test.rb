class ABPlugin
  class Test
    
    def initialize(test)
      @test = ABPlugin.tests.detect do |t|
        t['name'] == test || symbolize_name(t['name']) == test
      end
    end
    
    def convert(name=nil, &block)
      return unless @test
      
      conversion = variant(Cookies.get(:conversions, @test))
      visit = variant(Cookies.get(:visits, @test))
      variant = variant(name)
      
      already_recorded = (visit && visit == conversion) || (!name && conversion)
      
      unless visit
        visit = variant
      end
      
      unless conversion
        conversion = visit
      end
      
      if conversion && (!name || conversion == variant)
        unless already_recorded
          Cookies.set(:conversions, @test, conversion)
          Cookies.set(:visits, @test, conversion)
        end
        
        if block_given?
          block.call(symbolize_name(conversion['name']))
        end
        
        symbolize_name(conversion['name'])
      end
    end
    
    def visit(name=nil, &block)
      return unless @test
      
      visit = variant(Cookies.get(:visits, @test))
      variant = variant(name)
      
      already_recorded = (visit && visit == variant) || (!name && visit)
      
      unless visit
        variants = @test['variants'].sort do |a, b|
          a['visits'] <=> b['visits']
        end
        visit = variants.first
      end
      
      if visit && (!name || visit == variant)
        unless already_recorded
          visit['visits'] += 1
          Cookies.set(:visits, @test, visit)
        end
        
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
      @test['variants'].detect do |t|
        t['id'] == id_or_name ||
        t['name'] == id_or_name ||
        symbolize_name(t['name']) == id_or_name
      end
    end
  end
end