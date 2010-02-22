class ABPlugin
  class Test
    
    def initialize(test)
      @test = ABPlugin.tests.detect do |t|
        t['name'] == test || symbolize_name(t['name']) == test
      end
    end
    
    def convert(name=nil, &block)
      return unless @test
      
      conversion = Cookies.get(:conversions, @test)
      visit = Cookies.get(:visits, @test)
      variant = variant(name)
      
      if conversion && variant && conversion == variant['id']
      # Already converted
        block.call if block_given?
      
      elsif !visit || visit == variant
      # Not yet converted
        block.call if block_given?
        Cookies.set(:conversions, @test, variant)
      
      elsif name.nil? && visit && block_given?
      # No variant specified and test has been visited
        block.call symbolize_name(visit['name'])
      end
      
      symbolize_name(visit['name']) if visit
    end
    
    def visit(name=nil, &block)
      return unless @test
      
      visit = Cookies.get(:visits, @test)
      variant = variant(name)
      
      if visit && variant && visit == variant
      # Already visited
        block.call if block_given?
        
      elsif name.nil? && visit && block_given?
      # No variant specified and test has been visited
        block.call symbolize_name(visit['name'])
      
      else
      # Not yet visited  
        variants = @test['variants'].sort do |a, b|
          a['visits'] <=> b['visits']
        end
        visit = variants.first
        if visit && (!variant || visit == variant)
          block.call if block_given?
          visit['visits'] += 1
          Cookies.set(:visits, @test, visit)
        end
      end
      
      symbolize_name(visit['name']) if visit
    end
    
    private
    
    def symbolize_name(name)
      name.downcase.gsub(/[^a-zA-Z0-9\s]/, '').gsub('_', '').intern
    end
    
    def variant(name)
      return unless name && @test
      @test['variants'].detect do |t|
        t['name'] == name || symbolize_name(t['name']) == name
      end
    end
  end
end