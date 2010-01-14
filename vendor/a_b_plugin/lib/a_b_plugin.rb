require 'rubygems'
gem 'httparty', '=0.5.0'

require 'httparty'
require 'yaml'

require File.dirname(__FILE__) + "/a_b_plugin/core_ext/array"
require File.dirname(__FILE__) + "/a_b_plugin/core_ext/module"
require File.dirname(__FILE__) + "/a_b_plugin/api"
require File.dirname(__FILE__) + "/a_b_plugin/helper"
require File.dirname(__FILE__) + "/a_b_plugin/adapters/rails" if defined?(Rails)
require File.dirname(__FILE__) + "/a_b_plugin/adapters/sinatra" if defined?(Sinatra)

module ABPlugin
  
  mattr_accessor :cached_at
  mattr_accessor :config
  mattr_accessor :session
  mattr_accessor :session_id
  mattr_accessor :tests
  mattr_accessor :url
  mattr_accessor :user_token
  
  class <<self
    
    def active?
      @@session && @@session_id && @@tests && @@url && @@user_token
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
    
    def generate_token
      friendly = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      newpass = ""
      1.upto(20) { |i| newpass << friendly[rand(friendly.size-1)] }
      newpass
    end
    
    def reload
      if @@config
        data = File.dirname(@@config) + "/a_b_data.yml"
      end
      if @@config && File.exists?(@@config) && File.exists?(data)
        config = YAML::load(File.open(@@config))
        config = defined?(RACK_ENV) ? config[RACK_ENV] : config[RAILS_ENV]
        data = YAML::load(File.open(data))
        @@cached_at = Time.now
        @@tests = data['tests']
        @@user_token = data['user_token']
        @@url = config['url']
      else
        @@cached_at = Time.now - 50 * 60 # Try again in 10 minutes
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