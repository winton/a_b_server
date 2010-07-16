require 'rubygems'
require 'bundler'

Bundler.require(:lib)

require 'json'

$:.unshift File.dirname(__FILE__) + '/a_b'
$:.unshift File.expand_path(File.dirname(__FILE__) + '/../vendor/a_b_plugin/lib')
$:.unshift File.expand_path(File.dirname(__FILE__) + '/../vendor/delayed_job/lib')

require 'version'

require 'a_b_plugin'
require 'delayed_job'

require 'boot/application'
require 'boot/sinatra'
require 'boot/active_wrapper'
require 'boot/lilypad'
require 'boot/controller'
require 'boot/helper'
require 'boot/model'