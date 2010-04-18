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
  @category = Category.new(
    :name => 'category',
    :user_id => @user.id
  )
  @category.id = 1
  @env = Env.new(
    :name => 'env',
    :user_id => @user.id
  )
  @env.id = 1
  @test = ABTest.new(
    :name => 'test',
    :category_id => @category.id,
    :user_id => @user.id
  )
  @test.id = 1
  @variant = Variant.new(
    :name => 'variant',
    :category_id => @category.id,
    :test_id => @test.id,
    :user_id => @user.id
  )
  @variant.id = 1
  @category.save
  @env.save
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
  User.delete_all
  Variant.delete_all
end