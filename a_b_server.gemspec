# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'a_b_server/gems'
require 'a_b_server/version'

Gem::Specification.new do |s|
  s.name = "a_b_server"
  s.version = ABServer::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Winton Welsh"]
  s.email = ["mail@wintoni.us"]
  s.homepage = "http://github.com/winton/a_b_server"
  s.summary = ""
  s.description = ""

  ABServer::Gems::TYPES[:gemspec].each do |g|
    s.add_dependency g.to_s, ABServer::Gems::VERSIONS[g]
  end
  
  ABServer::Gems::TYPES[:gemspec_dev].each do |g|
    s.add_development_dependency g.to_s, ABServer::Gems::VERSIONS[g]
  end

  s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  s.executables = Dir.glob("{bin}/*").collect { |f| File.basename(f) }
  s.require_path = 'lib'
end