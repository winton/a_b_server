require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ABRequest do
  
  before(:each) do
    ABRequest.delete_all
  end
  
  after(:all) do
    ABRequest.delete_all
  end
  
  describe :process! do
  end
  
  describe :take_lock do
    
    before(:each) do
      @request = ABRequest.create
      Lock.create :start => @request.id, :end => @request.id
      @request2 = ABRequest.create
    end
    
    after(:each) do
      Lock.delete_all
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
end
