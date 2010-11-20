require File.expand_path('../../gems', __FILE__)

ABServer::Gems.require(:console)

$:.unshift File.dirname(__FILE__) + '/../'

require 'boot/application'
require 'boot/sinatra'
require 'boot/active_wrapper'
require 'boot/delayed_job'
require 'boot/model'
require 'boot/job'