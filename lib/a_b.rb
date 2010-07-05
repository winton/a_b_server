require 'rubygems'
require 'bundler'

Bundler.require(:lib)

$:.unshift File.dirname(__FILE__) + '/a_b'
$:.unshift File.expand_path(File.dirname(__FILE__) + '../vendor/a_b_plugin/lib')
$:.unshift File.expand_path(File.dirname(__FILE__) + '../vendor/delayed_job/lib')

require 'version'

require 'boot/application'
require 'boot/sinatra'
require 'boot/session'
require 'boot/flash'
require 'boot/active_wrapper'
require 'boot/lilypad'
require 'boot/controller'
require 'boot/helper'
require 'boot/model'