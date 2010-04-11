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
        ABVariant.should_receive(:record).and_return([ 0, 0 ])
        get('/a_b.js', :j => '{}', :i => 'identifier')
      end
      
      it "should limit an IP" do
        IP.create(:ip => '127.0.0.1', :count => IP::LIMIT_PER_DAY)
        ABVariant.should_not_receive(:record)
        get('/a_b.js', :j => '{}', :i => 'identifier')
      end
    end
    
    describe ABVariant do
      it "should update variant" do
        get('/a_b.js', :j => '{"v":[1],"c":[1],"e":["test"]}', :i => 'identifier')
        debug ABVariant.last
      end
    end
  end
end
