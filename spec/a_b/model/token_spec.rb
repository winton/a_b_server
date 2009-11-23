require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")

$time_now = Time.now

describe Token do
  
  before(:each) do
    $db.migrate_reset
    Token.send :reset
    Time.stub!(:now).and_return($time_now)
  end
  
  it "should generate a token if one does not exist" do
    Token.cached.first.length.should == 20
    Token.cached.length.should == 1
  end
  
  it "should re-cache tokens every minute" do
    Token.cached.length.should == 1
    Token.send :generate
    
    Time.stub!(:now).and_return($time_now + 59)
    Token.cached.length.should == 1
    
    Time.stub!(:now).and_return($time_now + 60)
    Token.cached.length.should == 2
  end
  
  it "should only cache the last two tokens" do
    Token.send :generate
    Token.send :generate
    Token.send :generate
    
    Token.count.should == 3
    Token.cached.length.should == 2
  end
  
  it "should generate a new token every hour" do
    Token.cached.length.should == 1
    
    Token.send :reset # Don't want the cache to interfere with these tests
    Time.stub!(:now).and_return($time_now + 60 * 60 - 1)
    Token.cached.length.should == 1
    
    Token.send :reset
    Time.stub!(:now).and_return($time_now + 60 * 60)
    Token.cached.length.should == 2
  end
end
