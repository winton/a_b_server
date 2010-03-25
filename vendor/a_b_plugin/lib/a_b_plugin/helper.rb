class ABPlugin
  module Helper
    
    private
    
    def a_b(test=nil)
      @a_b_plugin ||= ABPlugin.new(self)
      
      if test
        Test.new(test)
      
      elsif ABPlugin.tests && Config.url
        "a_b_setup(#{{
          :tests => ABPlugin.tests,
          :url => Config.url
        }.to_json});"
      end
    end
  end
end