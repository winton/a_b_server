require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe 'api' do
  
  include Rack::Test::Methods
  
  def app
    Application.new
  end
  
  before(:all) do
    teardown_tests
  end
  
  before(:each) do
    setup_tests
  end
  
  after(:each) do
    teardown_tests
  end
  
  describe '/' do
    it "should show a blank page" do
      get '/'
      last_response.body.should == ''
    end
  end
  
  describe '/a_b.js' do
    describe 'IP' do
      
      it "should create an IP" do
        get('/a_b.js')
        IP.count.should == 1
        ip = IP.first
        ip.ip.should == '127.0.0.1'
        ip.date.should == Date.today
        ip.count.should == 1
      end
      
      it "should create a new IP each day" do
        IP.create(:ip => '127.0.0.1', :count => 1, :date => Date.today - 1)
        get('/a_b.js')
        IP.count.should == 2
      end
      
      it "should increment an IP" do
        IP.create(:ip => '127.0.0.1', :count => 1)
        get('/a_b.js')
        IP.count.should == 1
        IP.first.count.should == 2
      end
      
      it "should not limit an IP" do
        get('/a_b.js')
        IP.first.update_attribute(:count, IP::LIMIT_PER_DAY - 1)
        ABVariant.should_receive(:record)
        ABRequest.should_receive(:record)
        get('/a_b.js', :j => '{}', :i => 'identifier')
      end
      
      it "should limit an IP" do
        IP.create(:ip => '127.0.0.1', :count => IP::LIMIT_PER_DAY)
        ABVariant.should_not_receive(:record)
        ABRequest.should_not_receive(:record)
        get('/a_b.js', :j => '{}', :i => 'identifier')
      end
    end
    
    describe ABVariant do
      it "should create variant" do
        get('/a_b.js', :j => '{"v":[1],"c":[1],"e":["test"]}', :i => 'identifier')
        variant = ABVariant.last
        variant.conversions.should == 1
        variant.visits.should == 1
        variant.conversion_extras.should == { 'test' => 1 }
        variant.visit_extras.should == { 'test' => 1 }
        variant.test_id.should == 1
      end
      
      it "should update variant" do
        get('/a_b.js', :j => '{"v":[1],"c":[1],"e":["test"]}', :i => 'identifier')
        get('/a_b.js', :j => '{"v":[1],"c":[1],"e":["test"]}', :i => 'identifier')
        variant = ABVariant.last
        variant.conversions.should == 2
        variant.visits.should == 2
        variant.conversion_extras.should == { 'test' => 2 }
        variant.visit_extras.should == { 'test' => 2 }
        variant.test_id.should == 1
      end
    end
    
    describe ABRequest do
      it "should create request" do
        get('/a_b.js', :j => '{"v":[1],"c":[1],"e":["test"]}', :i => 'identifier')
        r = ABRequest.last
        r.found_duplicate.should == false
        r.identifier.should == 'identifier'
        r.ip.should == '127.0.0.1'
        r.visits.should == 1
        r.conversions.should == 1
        r.visit_ids.should == [1]
        r.conversion_ids.should == [1]
      end
      
      it "should update request" do
        get('/a_b.js', :j => '{"v":[1],"c":[1],"e":["test"]}', :i => 'identifier')
        get('/a_b.js', :j => '{"v":[1],"c":[1],"e":["test"]}', :i => 'identifier')
        r = ABRequest.last
        r.found_duplicate.should == true
        r.identifier.should == 'identifier'
        r.ip.should == '127.0.0.1'
        r.visits.should == 2
        r.conversions.should == 2
        r.visit_ids.should == [1,1]
        r.conversion_ids.should == [1,1]
      end
    end
  end
end
