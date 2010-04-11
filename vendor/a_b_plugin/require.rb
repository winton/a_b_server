require 'rubygems'
gem 'require'
require 'require'

Require do
  gem(:httparty, '=0.5.2') { require 'httparty' }
  gem(:json, '=1.2.0') { require 'json' }
  gem(:'rack-test', '=0.5.3') { require 'rack/test' }
  gem(:rake, '=0.8.7') { require 'rake' }
  gem :require, '=0.2.2'
  gem :rspec, '=1.3.0'
  gem(:sinatra, '=0.9.4') { require 'sinatra/base' }
  
  gemspec do
    author 'Winton Welsh'
    dependencies do
      gem :require
    end
    email 'mail@wintoni.us'
    name 'a_b_plugin'
    homepage "http://github.com/winton/#{name}"
    summary "Talk to a_b from your Rails or Sinatra app"
    version '0.1.0'
  end
  
  bin { require 'lib/a_b_plugin' }
  
  lib do
    gem :httparty
    require 'yaml'
    require "lib/a_b_plugin/api"
    require "lib/a_b_plugin/config"
    require "lib/a_b_plugin/cookies"
    require "lib/a_b_plugin/datastore"
    require "lib/a_b_plugin/helper"
    require "lib/a_b_plugin/test"
    require "lib/a_b_plugin/yaml"
  end
  
  rails_init { require 'lib/a_b_plugin' }
  
  rakefile do
    gem(:rake) { require 'rake/gempackagetask' }
    gem(:rspec) { require 'spec/rake/spectask' }
    require 'require/tasks'
  end
  
  spec_helper do
    gem :json
    gem :'rack-test'
    gem :sinatra
    require 'require/spec_helper'
    require 'pp'
    require 'spec/fixtures/rails/config/environment'
    require 'spec/fixtures/sinatra'
    require 'rails/init'
  end
end