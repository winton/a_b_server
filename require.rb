require 'rubygems'
gem 'require'
require 'require'

Require do
  
  gem(:active_wrapper, '=0.2.5') { require 'active_wrapper' }
  gem :cucumber, '=0.6.2'
  gem(:haml, '=2.2.17') { require %w(haml sass) }
  gem(:lilypad, '=0.3.0') { require 'lilypad' }
  gem(:rake, '=0.8.7') { require 'rake' }
  gem(:'rack-test', '=0.5.3') { require 'rack/test' }
  gem :require, '=0.2.2'
  gem :rspec, '=1.3.0'
  gem(:newrelic_rpm, '=2.10.6') { require 'newrelic_rpm' }
  gem(:sinatra, '=0.9.4') { require 'sinatra/base' }
  gem(:with_pid, '=0.1.0') { require 'with_pid' }
  
  gemspec do
    author 'Winton Welsh'
    dependencies do
      gem :active_wrapper
      gem :haml
      gem :lilypad
      gem :require
      gem :sinatra
    end
    email 'mail@wintoni.us'
    name 'a_b'
    homepage "http://github.com/winton/#{name}"
    summary ""
    version '0.1.0'
  end
  
  bin { require 'lib/a_b' }
  
  console do
    gem :active_wrapper
    gem :sinatra
    load_path 'vendor/a_b_plugin/lib'
    load_path 'vendor/delayed_job/lib'
    require 'a_b_plugin'
    require 'delayed_job'
    require 'lib/a_b/boot/application'
    require 'lib/a_b/boot/sinatra'
    require 'lib/a_b/boot/active_wrapper'
    require 'lib/a_b/boot/model'
  end
  
  dj { gem :with_pid }
  
  lib do
    gem :active_wrapper
    gem :haml
    gem :rack, "1.0.1"
    gem :sinatra
    gem :newrelic_rpm
    load_path 'vendor/a_b_plugin/lib'
    load_path 'vendor/delayed_job/lib'
    require 'a_b_plugin'
    require 'delayed_job'
    require 'lib/a_b/boot/application'
    require 'lib/a_b/boot/sinatra'
    require 'lib/a_b/boot/active_wrapper'
    require 'lib/a_b/boot/lilypad'
    require 'lib/a_b/boot/controller'
    require 'lib/a_b/boot/helper'
    require 'lib/a_b/boot/job'
    require 'lib/a_b/boot/model'
  end
  
  rakefile do
    gem(:active_wrapper) { require 'active_wrapper/tasks' }
    gem(:rake) { require 'rake/gempackagetask' }
    gem(:rspec) { require 'spec/rake/spectask' }
    gem :sinatra
    require 'require/tasks'
    require 'lib/a_b/boot/application'
    require 'lib/a_b/boot/sinatra'
    require 'lib/a_b/boot/active_wrapper'
    require 'lib/a_b/boot/model'
  end
  
  spec_helper do
    gem :'rack-test'
    require 'require/spec_helper'
    require 'lib/a_b'
    require 'pp'
  end
end