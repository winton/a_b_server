require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ABRequest do
  describe :record do
    
    before(:each) do
      ABRequest.delete_all
      @request = mock(:request)
      @request.stub!(:env).and_return({ 'HTTP_USER_AGENT' => 'user agent' })
      @request.stub!(:ip).and_return('127.0.0.1')
    end
    
    it "should create a record" do
      r = ABRequest.record('identifier', @request, [ 1 ], [ 1 ])
      r.agent.should == 'user agent'
      r.found_duplicate.should == false
      r.identifier.should == "identifier"
      r.ip.should == "127.0.0.1"
      r.visits.should == 1
      r.conversions.should == 1
      r.visit_ids.should == [ 1 ]
      r.conversion_ids.should == [ 1 ]
    end
    
    it "should record duplicates" do
      ABRequest.record('identifier', @request, [ 1 ], [ 1 ])
      r = ABRequest.record('identifier', @request, [ 1 ], [ 1 ])
      r.agent.should == 'user agent'
      r.found_duplicate.should == true
      r.identifier.should == "identifier"
      r.ip.should == "127.0.0.1"
      r.visits.should == 2
      r.conversions.should == 2
      r.visit_ids.should == [ 1, 1 ]
      r.conversion_ids.should == [ 1, 1 ]
      ABRequest.count.should == 1
    end
  end
end
