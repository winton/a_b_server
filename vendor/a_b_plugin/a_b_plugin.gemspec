# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

<<<<<<< HEAD:vendor/a_b_plugin/a_b_plugin.gemspec
require 'a_b_plugin/version'
require 'rubygems'
require 'bundler'
=======
require 'gem_template/gems'
require 'gem_template/version'
>>>>>>> e123383b76eaabbfc779168aa182ad723be8601a:gem_template.gemspec

Gem::Specification.new do |s|
  s.name = "a_b_plugin"
  s.version = ABPlugin::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Winton Welsh"]
  s.email = ["mail@wintoni.us"]
  s.homepage = "http://github.com/winton/a_b_plugin"
  s.summary = "Talk to a_b from your Rails or Sinatra app"
  s.description = "Provides the a_b method to your application controller and helper"

  GemTemplate::Gems::TYPES[:gemspec].each do |g|
    s.add_dependency g.to_s, GemTemplate::Gems::VERSIONS[g]
  end
  
  GemTemplate::Gems::TYPES[:gemspec_dev].each do |g|
    s.add_development_dependency g.to_s, GemTemplate::Gems::VERSIONS[g]
  end

  s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  s.executables = Dir.glob("{bin}/*").collect { |f| File.basename(f) }
  s.require_path = 'lib'
end