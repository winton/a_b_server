Then /^respond with test names$/ do
  @json['tests'][0]['name'].should == 'Test'
end

Then /^respond with variant names with visit counts$/ do
  @json['tests'][0]['variants'].should == [
    {"name"=>"v1", "visitors"=>0},
    {"name"=>"v2", "visitors"=>0},
    {"name"=>"v3", "visitors"=>0}
  ]
end

Then /^respond with a JSON\-P security token$/ do
  @json['user_token'].length.should == 20
end

Then /^increment conversions for each variant$/ do
  conversions = ABVariant.find(:all).collect &:conversions
  conversions.should == Array.new(3, 1)
end

Then /^increment visitors for each variant$/ do
  visitors = ABVariant.find(:all).collect &:visitors
  visitors.should == Array.new(3, 1)
end