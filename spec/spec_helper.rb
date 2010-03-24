require File.expand_path("#{File.dirname(__FILE__)}/../require")
Require.spec_helper!

Spec::Runner.configure do |config|
end

def create_request
  @user = User.create
  @test = ABTest.create(
    :name => 'test',
    :user_id => @user.id
  )
  @variant = ABVariant.create(
    :name => 'variant',
    :test_id => @test.id
  )
  @request = ABRequest.create(
    :data => {
      'c' => { @test.id => @variant.id },
      'v' => { @test.id => @variant.id },
      'e' => { @variant.id => { 'e' => true } }
    },
    :ip => '127.0.0.1'
  )
end

def destroy_request
  @user.destroy
  @request.destroy
  ABRequest.reset
end