require File.dirname(__FILE__) + "/a_b_plugin/core_ext/array"
require File.dirname(__FILE__) + "/a_b_plugin/core_ext/module"
require File.dirname(__FILE__) + "/a_b_plugin/api"
require File.dirname(__FILE__) + "/a_b_plugin/helper"
require File.dirname(__FILE__) + "/a_b_plugin/adapters/rails" if defined?(Rails)
require File.dirname(__FILE__) + "/a_b_plugin/adapters/sinatra" if defined?(Sinatra)

module ABPlugin
  
  mattr_accessor :cached_at
  mattr_accessor :disable_boot
  mattr_accessor :session_id
  mattr_accessor :tests
  mattr_accessor :token
  mattr_accessor :url
  mattr_accessor :user_token
  
  class <<self
    
    def active?
      @@cached_at && @@session_id && @@tests && @@token && @@url && @@user_token
    end
    
    def convert(variant, conversions, selections, visits)
      test = find_test(variant)
      return unless test
      conversions ||= {}
      conversions[test['name']] = variant
      [ conversions, selections, visits ]
    end
    
    def find_test(test_or_variant)
      return unless @@tests
      tests = @@tests.select do |t|
        t['name'] == test_or_variant || variant_names(t).include?(test_or_variant)
      end
      tests.first
    end
    
    def reload
      unless @@disable_boot
        begin
          @@cached_at = Time.now
          boot = ABPlugin::API.boot @@token, @@url
          @@tests = boot['tests']
          @@user_token = boot['user_token']
        rescue Exception => e
          @@cached_at = Time.now - 50 * 60 # Try again in 10 minutes
          @@tests = nil
          @@user_token = nil
        end
      end
    end
    
    def reload?
      @@cached_at.nil? || (Time.now - @@cached_at).to_i >= 60 * 60
    end
    
    def select(test_or_variant, selections)
      test = find_test(test_or_variant)
      return [ selections ] unless test
      
      selections ||= {}
      unless selections[test['name']]
        variants = test['variants'].sort do |a, b|
          a['visits'] <=> b['visits']
        end
        if variants.first
          variants.first['visits'] += 1
          selections[test['name']] = variants.first['name']
        end
      end
      
      [ selections,
        test['name'],
        selections[test['name']]
      ]
    end
    
    def test_names
      @@tests.collect { |t| t['name'] }
    end
    
    def variant_names(test=nil)
      variants = lambda do |t|
        t['variants'].collect { |v| v['name'] }
      end
      if test
        variants.call(test)
      else
        @@tests.collect { |t| variants.call(t) }.flatten
      end
    end
    
    def visit(variant, conversions, selections, visits)
      test = find_test(variant)
      return unless test
      visits ||= {}
      visits[test['name']] = variant
      [ conversions, selections, visits ]
    end
  end
end