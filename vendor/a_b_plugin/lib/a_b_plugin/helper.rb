class ABPlugin
  module Helper
    
    private
    
    def a_b(test=nil)
      @a_b_plugin ||= ABPlugin.new(self)
      
      if test
        Test.new(test)
      
      elsif ABPlugin.tests && Config.url
        "<script type='text/javascript'>A_B.setup(#{{
          :tests => ABPlugin.tests,
          :url => Config.url
        }.to_json});</script>"
      end
    end
  end
end