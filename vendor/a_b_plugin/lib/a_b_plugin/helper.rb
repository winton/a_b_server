module ABPlugin
  module Helper
    
    private
    
    def a_b_convert(test_or_variant, &block)
      a_b_select(test_or_variant, :convert, &block)
    end
    
    def a_b_script_tag(path=nil)
      return unless ABPlugin.active?
      options = {
        :conversions => @a_b_conversions || {},
        :selections => @a_b_selections || {},
        :session_id => ABPlugin.session_id,
        :tests => ABPlugin.tests,
        :token => Digest::SHA256.hexdigest(ABPlugin.session_id + ABPlugin.user_token),
        :url => ABPlugin.url,
        :visits => @a_b_visits || {}
      }
      if path
        path = "<script src='#{path}' type='text/javascript'></script>"
      else
        path = nil
      end
      "#{path}<script type='text/javascript'>A_B.setup(#{options.to_json});</script>"
    end
    
    def a_b_select(test_or_variant, type=nil, &block)
      return unless ABPlugin.active?
      @a_b_selections, test, variant = ABPlugin.select(test_or_variant, @a_b_selections)
      if test_or_variant == test || test_or_variant == variant
        if type
          @a_b_conversions, @a_b_selections, @a_b_visits = ABPlugin.send(
            type, variant, @a_b_conversions, @a_b_selections, @a_b_visits
          )
        end
        yield(test, variant) if block_given?
      end
    end
    
    def a_b_visit(test_or_variant, &block)
      a_b_select(test_or_variant, :visit, &block)
    end
  end
end