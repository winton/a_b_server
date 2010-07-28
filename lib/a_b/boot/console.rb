require File.expand_path('../../gems', __FILE__)

AB::Gems.require(:console)

$:.unshift File.dirname(__FILE__) + '/../'

require 'boot/a_b_plugin'
require 'boot/delayed_job'

require 'boot/application'
require 'boot/sinatra'
require 'boot/active_wrapper'
require 'boot/model'