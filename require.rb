require 'rubygems'
gem 'require'
require 'require'

Require do
  
  gem(:active_wrapper, '=0.2.3') { require 'active_wrapper' }
  gem :cucumber, '=0.6.2'
  gem(:daemons, '=1.0.10') { require %w(daemons optparse) }
  gem(:haml, '=2.2.17') { require %w(haml sass) }
  gem(:lilypad, '=0.3.0') { require 'lilypad' }
  gem(:rake, '=0.8.7') { require 'rake' }
  gem :require, '=0.1.6'
  gem :rspec, '=1.3.0'
  gem(:sinatra, '=0.9.4') { require 'sinatra/base' }
  
  gemspec do
    author 'Winton Welsh'
    dependencies do
      gem :active_wrapper
      gem :daemons
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
    require 'a_b_plugin'
    require 'lib/a_b/boot/application'
    require 'lib/a_b/boot/sinatra'
    require 'lib/a_b/boot/active_wrapper'
    require 'lib/a_b/boot/model'
  end
  
  daemon do
    gem :active_wrapper
    gem :daemons
    gem :sinatra
    load_path 'vendor/a_b_plugin/lib'
    require 'a_b_plugin'
    require 'lib/a_b/boot/application'
    require 'lib/a_b/boot/sinatra'
    require 'lib/a_b/boot/active_wrapper'
    require 'lib/a_b/boot/model'
    require 'lib/a_b/boot/daemon'
  end
  
  lib do
    gem :haml
    gem :sinatra
    gem :active_wrapper
    load_path 'vendor/a_b_plugin/lib'
    require 'a_b_plugin'
    require 'lib/a_b/boot/application'
    require 'lib/a_b/boot/sinatra'
    require 'lib/a_b/boot/active_wrapper'
    require 'lib/a_b/boot/lilypad'
    require 'lib/a_b/boot/controller'
    require 'lib/a_b/boot/helper'
    require 'lib/a_b/boot/model'
  end
  
  rakefile do
    gem(:active_wrapper) { require 'active_wrapper/tasks' }
    gem(:rake) { require 'rake/gempackagetask' }
    gem(:rspec) { require 'spec/rake/spectask' }
    require 'require/tasks'
  end
  
  spec_helper do
    require 'require/spec_helper'
    require 'lib/a_b'
    require 'pp'
  end
end