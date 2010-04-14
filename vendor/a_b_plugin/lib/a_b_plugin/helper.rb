class ABPlugin
  module Helper
    
    private
    
    def a_b(category=nil, test=nil, extra=nil)
      @a_b_plugin ||= ABPlugin.new(self)
      
      if category || test || extra
        Test.new(category, test, extra)
      
      elsif ABPlugin.categories && Config.url
        "a_b_setup(#{{
          :categories => ABPlugin.categories,
          :env => Config.env,
          :site => Config.site,
          :url => Config.url
        }.to_json});"
      end
    end
  end
end