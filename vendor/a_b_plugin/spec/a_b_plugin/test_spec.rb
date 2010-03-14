require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ABPlugin::Test do
  
  before(:each) do
    ABPlugin do
      root SPEC + '/fixtures/tests_yaml'
    end
  end
  
  after(:each) do
    ABPlugin.reset
  end
  
  describe 'visit' do
    
    it "should return the variant name" do
      a_b(:test).visit.should == :v1
    end
    
    it "should return the variant name every time" do
      a_b(:test).visit
      a_b(:test).visit.should == :v1
    end
    
    it "should set cookie" do
      a_b(:test).visit
      JSON($cookies['a_b']).should == {"v"=>{"1"=>2}}
    end
    
    it "should increment variant visits" do
      a_b(:test).visit
      ABPlugin.tests[0]['variants'][0]['visits'].should == 1
    end
    
    it "should maintain state if called more than once" do
      a_b(:test).visit
      a_b(:test).visit
      ABPlugin.tests[0]['variants'][0]['visits'].should == 1
      JSON($cookies['a_b']).should == {"v"=>{"1"=>2}}
    end
    
    it "should return the variant name if variant specified and selected" do
      a_b(:test).visit(:v1).should == :v1
    end
    
    it "should return nil if variant specified and not selected" do
      a_b(:test).visit(:v1)
      a_b(:test).visit(:v2).should == nil
    end
    
    it "should accept a block and pass the selected variant name to it" do
      ran = false
      a_b(:test).visit do |variant|
        ran = true
        variant.should == :v1
      end
      ran.should == true
    end
    
    it "should accept a block for a specific variant" do
      ran = false
      a_b(:test).visit(:v1) do
        ran = true
      end
      ran.should == true
    end
    
    it "should not call a block for a specific variant if the variant is not selected" do
      ran = false
      a_b(:test).visit(:v2) do
        ran = true
      end
      ran.should == false
    end
  end
  
  describe 'convert' do
    
    before(:each) do
      a_b(:test).visit
    end
    
    it "should return the variant name" do
      a_b(:test).convert.should == :v1
    end
    
    it "should return the variant name every time" do
      a_b(:test).convert
      a_b(:test).convert.should == :v1
    end
    
    it "should set cookie" do
      a_b(:test).convert
      JSON($cookies['a_b']).should == {"v"=>{"1"=>2}, "c"=>{"1"=>2}}
    end
    
    it "should maintain state if called more than once" do
      a_b(:test).convert
      a_b(:test).convert
      JSON($cookies['a_b']).should == {"v"=>{"1"=>2}, "c"=>{"1"=>2}}
    end
    
    it "should return the variant name if variant specified and selected" do
      a_b(:test).convert(:v1).should == :v1
    end
    
    it "should return nil if variant specified and not selected" do
      a_b(:test).convert(:v1)
      a_b(:test).convert(:v2).should == nil
    end
    
    it "should accept a block and pass the selected variant name to it" do
      ran = false
      a_b(:test).convert do |variant|
        ran = true
        variant.should == :v1
      end
      ran.should == true
    end
    
    it "should accept a block for a specific variant" do
      ran = false
      a_b(:test).convert(:v1) do
        ran = true
      end
      ran.should == true
    end
    
    it "should not call a block for a specific variant if the variant is not selected" do
      ran = false
      a_b(:test).convert(:v2) do
        ran = true
      end
      ran.should == false
    end
  end
end
