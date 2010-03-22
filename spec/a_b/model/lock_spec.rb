require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Lock do
  
  before(:each) do
    Lock.delete_all
  end
  
  describe :release do
    
    before(:each) do
      @lock = Lock.create
    end
    
    it "should destroy the lock" do
      Lock.release @lock.id
      Lock.find_by_id(@lock.id).should == nil
    end
    
    it "should add a failed_at date and error message if exception specified" do
      exception = nil
      begin
        raise 'Test exception'
      rescue Exception => e
        exception = e
      end
      Lock.release @lock.id, e
      @lock.reload
      @lock.error.should =~ /Test exception/
      @lock.failed_at.to_s.should == Time.now.utc.to_s
    end
  end
  
  describe :take do
    
    it "should create a lock record" do
      id = Lock.take 1, 2
      lock = Lock.find id
      lock.name.should =~ /host:/
      lock.name.should =~ /pid:/
      lock.start.should == 1
      lock.end.should == 2
      lock.created_at.to_s.should == Time.now.utc.to_s
    end
  end
  
  describe :unlocked_conditions do
    
    before(:each) do
      Lock.create :start => 1, :end => 2
      Lock.create :start => 3, :end => 4
      Lock.create :start => 5, :end => 6, :failed_at => Time.now.utc
    end
    
    it "should return the correct conditions" do
      conditions = Lock.unlocked_conditions
      conditions.should == "(id < 1 AND id > 2) AND (id < 3 AND id > 4)"
    end
  end
end
