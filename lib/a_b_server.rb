require File.dirname(__FILE__) + '/a_b_server/gems'

ABServer::Gems.require(:lib)

require 'json'

$:.unshift File.dirname(__FILE__) + '/a_b_server'

require 'version'

require 'boot/application'
require 'boot/sinatra'
require 'boot/active_wrapper'
require 'boot/delayed_job'
require 'boot/lilypad'
require 'boot/controller'
require 'boot/helper'
require 'boot/model'
require 'boot/job'