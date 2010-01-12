Given /^a user exists for the application$/ do
  @user = User.quick_create 'user', 'password'
end

Given /^the application has an authorized single access token$/ do
  @params = { :token => @user.single_access_token }
end

Given /^test data exists$/ do
  ABTest.create :name => 'Test', :variants => 'v1, v2, v3'
end

Given /^the application provides an authorized session id\/token combination$/ do
  token = Digest::SHA256.hexdigest('abc' + Token.cached.first)
  @params ||= {}
  @params.merge!( :session_id => 'abc', :token => token )
end

Given /^the application provides a list of variant names to (.+)$/ do |convert_or_visit|
  @params ||= {}
  variants = "v1,v2,v3"
  case convert_or_visit
  when 'convert'
    @params.merge!(:conversions => variants)
  when 'visit'
    @params.merge!(:visits => variants)
  end
end