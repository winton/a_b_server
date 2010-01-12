require File.dirname(__FILE__) + '/spec_helper'

$time_now = Time.now

module ABPlugin
  describe ABPlugin do
    
    before(:each) do
      stub_api_boot
      Time.stub!(:now).and_return($time_now)
    end
    
    describe :convert do
      
      before(:each) do
        ABPlugin.tests = @tests
        @conversions = {}
        @selections = { 'Test' => 'v1' }
        @visits = {}
      end
      
      it "should add an entry to the conversions and visits hash if selected (given a test)" do
        ABPlugin.convert('Test', @conversions, @selections, @visits)
        @conversions.should == { "Test" => "v1" }
        @visits.should == { "Test" => "v1" }
      end
      
      it "should add an entry to the conversions and visits hash if selected (given a variant)" do
        ABPlugin.convert('v1', @conversions, @selections, @visits)
        @conversions.should == { "Test" => "v1" }
        @visits.should == { "Test" => "v1" }
      end
    end
    
    describe :reload do
      
      before(:each) do
        ABPlugin.token = @token
        ABPlugin.url = @url
        ABPlugin.session_id = @session_id
      end
      
      it "should call API.boot" do
        API.should_receive(:boot).with(@token, @url)
        ABPlugin.reload
      end
      
      it "should set class variables based on the response" do
        Time.stub!(:now).and_return($time_now)
        ABPlugin.reload
        ABPlugin.cached_at.should == $time_now
        ABPlugin.tests.should == @tests
        ABPlugin.user_token = @user_token
      end
    end
    
    describe :reload? do
      
      it "should return true if it has been an hour since the last cache" do
        Time.stub!(:now).and_return($time_now + 60 * 60)
        ABPlugin.reload?.should == true
      end
      
      it "should return false if it has been less than an hour since the last cache" do
        Time.stub!(:now).and_return($time_now + 60 * 60 - 1)
        ABPlugin.reload?.should == false
      end
    end
    
    describe :select do
      
      before(:each) do
        @selections = nil
        ABPlugin.stub!(:active?).and_return(true)
        ABPlugin.tests = @tests
      end
      
      it "should pick a variant given a test" do
        selections, variant = ABPlugin.select('Test', @selections)
        selections.class.should == Hash
        variant.class.should == String
      end
      
      it "should pick a variant given a variant" do
        selections, variant = ABPlugin.select('v1', @selections)
        selections.class.should == Hash
        variant.class.should == String
      end
      
      it "should select based on the least number of visits" do
        ABPlugin.tests.first['variants'][0]['visits'] = 0
        ABPlugin.tests.first['variants'][1]['visits'] = 1
        ABPlugin.tests.first['variants'][2]['visits'] = 1
        ABPlugin.select('Test', {}).should == [ { 'Test' => 'v1' }, 'Test', 'v1' ]
        
        ABPlugin.tests.first['variants'][0]['visits'] = 1
        ABPlugin.tests.first['variants'][1]['visits'] = 0
        ABPlugin.tests.first['variants'][2]['visits'] = 1
        ABPlugin.select('v1', {}).should == [ { 'Test' => 'v2' }, 'Test', 'v2' ]
        
        ABPlugin.tests.first['variants'][0]['visits'] = 1
        ABPlugin.tests.first['variants'][1]['visits'] = 1
        ABPlugin.tests.first['variants'][2]['visits'] = 0
        ABPlugin.select('Test', {}).should == [ { 'Test' => 'v3' }, 'Test', 'v3' ]
      end
    end
    
    describe :visit do
      
      before(:each) do
        ABPlugin.tests = @tests
        @conversions = {}
        @selections = { 'Test' => 'v1' }
        @visits = {}
      end
      
      it "should add an entry to the visits hash if selected (given a test)" do
        ABPlugin.visit('Test', @conversions, @selections, @visits)
        @conversions.should == {}
        @visits.should == { "Test" => "v1" }
      end
      
      it "should add an entry to the visits hash if selected (given a variant)" do
        ABPlugin.visit('v1', @conversions, @selections, @visits)
        @conversions.should == {}
        @visits.should == { "Test" => "v1" }
      end
    end
  end
end