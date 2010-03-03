require File.expand_path("#{File.dirname(__FILE__)}/../require")
Require.spec_helper!

ENV['RACK_ENV'] = 'testing'

Spec::Runner.configure do |config|
  include ABPlugin::Helper
end

def setup_variables
  @tests = [{
    "id" => 1,
    "name" => "Test",
    "variants" => [
      {
        "id" => 2,
        "name" => "v1",
        "visits" => 0
      },
      {
        "id" => 3,
        "name" => "v2",
        "visits" => 0
      },
      {
        "id" => 4,
        "name" => "v3",
        "visits" => 0
      }
    ]
  }]
end

def stub_api_boot
  setup_variables
  ABPlugin::API.stub!(:boot).and_return(
    "tests" => @tests
  )
end