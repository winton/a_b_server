# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'a_b_plugin/version'
require 'rubygems'
require 'bundler'

Gem::Specification.new do |s|
  s.name = "a_b_plugin"
  s.version = ABPlugin::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Winton Welsh"]
  s.email = ["mail@wintoni.us"]
  s.homepage = "http://github.com/winton/a_b_plugin"
  s.summary = "Talk to a_b from your Rails or Sinatra app"
  s.description = "Provides the a_b method to your application controller and helper"

  Bundler.definition.dependencies.each do |dep|
    if dep.groups.include?(:gemspec)
      s.add_dependency dep.name, dep.requirement
    elsif dep.groups.include?(:gemspec_dev)
      s.add_development_dependency dep.name, dep.requirement
    end
  end

  s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  s.executables = Dir.glob("{bin}/*").collect { |f| File.basename(f) }
  s.require_path = 'lib'
end