require File.dirname(__FILE__) + '/a_b/gems'

GemTemplate::Gems.require(:lib)

require 'json'

$:.unshift File.dirname(__FILE__) + '/a_b'

require 'version'

require 'boot/a_b_plugin'
require 'boot/delayed_job'

require 'boot/application'
require 'boot/sinatra'
require 'boot/active_wrapper'
require 'boot/lilypad'
require 'boot/controller'
require 'boot/helper'
require 'boot/model'