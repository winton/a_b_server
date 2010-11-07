$root = File.expand_path('../../', __FILE__)
require "#{$root}/lib/a_b/gems"

AB::Gems.require(:spec)

require 'rack/test'

ENV['RACK_ENV'] = 'test'

require "#{$root}/lib/a_b"
require 'pp'

Spec::Runner.configure do |config|
end

# For use with rspec textmate bundle
def debug(object)
  puts "<pre>"
  puts object.pretty_inspect.gsub('<', '&lt;').gsub('>', '&gt;')
  puts "</pre>"
end

def setup_tests
  @user = User.new(
    :admin => true,
    :identifier => 'identifier',
    :token => 'token'
  )
  @user.id = 1
  @site = Site.new(
    :name => 'site.com',
    :user_id => @user.id
  )
  @site.id = 1
  @category = Category.new(
    :name => 'category',
    :site_id => @site.id,
    :user_id => @user.id
  )
  @category.id = 1
  @env = Env.new(
    :name => 'env',
    :domains => 'localhost,a.site.com,test.com',
    :site_id => @site.id,
    :user_id => @user.id
  )
  @env.id = 1
  @test = ABTest.new(
    :name => 'test',
    :category_id => @category.id,
    :site_id => @site.id,
    :user_id => @user.id
  )
  @test.id = 1
  @variant = Variant.new(
    :name => 'variant',
    :category_id => @category.id,
    :site_id => @site.id,
    :test_id => @test.id,
    :user_id => @user.id
  )
  @variant.id = 1
  @category.save
  @env.save
  @site.save
  @test.save
  @user.save
  @variant.save
end

def teardown_tests
  ABRequest.delete_all
  ABTest.delete_all
  Category.delete_all
  Env.delete_all
  IP.delete_all
  Site.delete_all
  User.delete_all
  Variant.delete_all
end