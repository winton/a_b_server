require File.expand_path("#{File.dirname(__FILE__)}/../require")
Require.spec_helper!

Spec::Runner.configure do |config|
end

def setup_tests
  @user = User.new(
    :admin => true,
    :identifier => 'identifier',
    :token => 'token'
  )
  @user.id = 1
  @test = ABTest.new(
    :name => 'test',
    :user_id => @user.id
  )
  @test.id = 1
  @variant = ABVariant.new(
    :name => 'variant',
    :test_id => @test.id
  )
  @variant.id = 1
  @user.save
  @test.save
  @variant.save
end

def teardown_tests
  IP.delete_all
  ABRequest.delete_all
  ABTest.delete_all
  User.delete_all
  ABVariant.delete_all
end