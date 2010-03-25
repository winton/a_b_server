require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ABRequest do
  
  before(:all) do
    cleanup
  end
  
  after(:each) do
    cleanup
  end
  
  describe :increment do
    
    before(:each) do
      create_request
    end
    
    it 'should increment conversions, visits, and extras' do
      ABRequest.increment(@request)
      @variant.reload
      @variant.conversions.should == 1
      @variant.visits.should == 1
      @variant.extras.should == { 'e' => 1 }
      
      ABRequest.increment(@request)
      @variant.reload
      @variant.conversions.should == 2
      @variant.visits.should == 2
      @variant.extras.should == { 'e' => 2 }
    end
  end
  
  describe :limit_ip do
    
    before(:each) do
      @old_ip_limit = IP::LIMIT_PER_DAY
      IP::LIMIT_PER_DAY = 1
      create_request
    end
    
    after(:each) do
      IP::LIMIT_PER_DAY = @old_ip_limit
    end
    
    it 'should start limiting once limit has been reached' do
      ABRequest.limit_ip(@request).should == false
      ip = IP.first
      ip.ip.should == '127.0.0.1'
      ip.count.should == 1
      ip.date.to_s.should == Date.parse(@request.created_at.strftime('%Y/%m/%d')).to_s
      ABRequest.limit_ip(@request).should == true
    end
  end
  
  describe :take_lock do
    
    before(:each) do
      @request = ABRequest.create
      Lock.create :start => @request.id, :end => @request.id
      @request2 = ABRequest.create
    end
    
    it 'should return conditions and a lock id' do
      pair = ABRequest.take_lock
      pair[0].should == "(id NOT BETWEEN #{@request.id} AND #{@request.id})"
      pair[1].class.should == Fixnum
    end
    
    it 'should create the lock' do
      pair = ABRequest.take_lock
      lock = Lock.find pair[1]
      lock.start.should == @request2.id
      lock.end.should == @request2.id
    end
  end
  
  describe :user do
    
    before(:each) do
      create_request
    end
    
    it 'should find the user from the request' do
      ABRequest.user(@request).should == @user
    end
  end
end
