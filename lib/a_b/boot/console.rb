require 'rubygems'
require 'bundler'

Bundler.require(:console)

$:.unshift File.dirname(__FILE__) + '/../'
$:.unshift File.expand_path(File.dirname(__FILE__) + '../../../../vendor/a_b_plugin/lib')
$:.unshift File.expand_path(File.dirname(__FILE__) + '../../../../vendor/delayed_job/lib')

require 'a_b_plugin'
require 'delayed_job'

require 'boot/application'
require 'boot/sinatra'
require 'boot/active_wrapper'
require 'boot/model'