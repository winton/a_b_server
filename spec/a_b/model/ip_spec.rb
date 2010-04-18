require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe IP do
  
  before(:each) do
    IP.delete_all
  end
  
  describe :create_or_increment do
    
    before(:each) do
      @ip = IP.create_or_increment('127.0.0.1')
    end
    
    describe :create do
      
      it "should create" do
        IP.count.should == 1
        IP.first.should == @ip
      end
    
      it "should set attributes" do
        @ip.ip.should == '127.0.0.1'
        @ip.date.should == Date.today
        @ip.count.should == 1
      end
    end
    
    describe :increment do
      
      before(:each) do
        @ip = IP.create_or_increment('127.0.0.1')
      end
      
      it "should not create" do
        IP.count.should == 1
        IP.first.should == @ip
      end
      
      it "should set attributes" do
        @ip.ip.should == '127.0.0.1'
        @ip.date.should == Date.today
        @ip.count.should == 2
      end
    end
  end
  
  describe :limited? do
    
    before(:each) do
      @ip = IP.create(:ip => '127.0.0.1', :count => IP::LIMIT_PER_DAY)
    end
    
    it "should not be limited" do
      @ip.limited?.should == false
    end
    
    it "should be limited" do
      IP.create_or_increment('127.0.0.1')
      @ip.reload
      @ip.limited?.should == true
    end
  end
end
