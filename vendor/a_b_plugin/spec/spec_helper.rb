require File.expand_path("#{File.dirname(__FILE__)}/../require")
Require.spec_helper!

$testing = true

Spec::Runner.configure do |config|
  include ABPlugin::Helper
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
  ABPlugin::API.stub!(:site).and_return(@site)
end