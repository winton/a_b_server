$root = File.expand_path('../../', __FILE__)
$testing = true

require "#{$root}/lib/a_b_plugin/gems"

ABPlugin::Gems.require(:spec)

require 'json'
require 'rack/test'
require 'pp'

require "#{$root}/spec/fixtures/rails/config/environment"
require "#{$root}/spec/fixtures/sinatra"

require "#{$root}/lib/a_b_plugin"

require "#{$root}/rails/init"

Spec::Runner.configure do |config|
  include ABPlugin::Helper
end

# For use with rspec textmate bundle
def debug(object)
  puts "<pre>"
  puts object.pretty_inspect.gsub('<', '&lt;').gsub('>', '&gt;')
  puts "</pre>"
end

def setup_variables
  @site = {
    "categories" => [{
      "name" => "Category",
      "tests" => [{
        "id" => 1,
        "name" => "Test",
        "variants" => [
          {
            "id" => 2,
            "name" => "v1"
          },
          {
            "id" => 3,
            "name" => "v2"
          },
          {
            "id" => 4,
            "name" => "v3"
          }
        ]
      }]
    }]
  }
end

def stub_api_boot
  setup_variables
  ABPlugin::API.stub!(:sites).and_return(@site)
end