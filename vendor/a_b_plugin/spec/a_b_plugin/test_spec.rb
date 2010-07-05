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
      a_b(:category, :test).visit.should == :v1
    end
    
    it "should return the variant name every time" do
      a_b(:category, :test).visit
      a_b(:category, :test).visit.should == :v1
    end
    
    it "should set cookie" do
      a_b(:category, :test).visit
      JSON($cookies['a_b_s']).should == {"v"=>[2]}
    end
    
    it "should maintain state if called more than once" do
      a_b(:category, :test).visit
      a_b(:category, :test).visit
      JSON($cookies['a_b_s']).should == {"v"=>[2]}
    end
    
    it "should return the variant name if variant specified and selected" do
      a_b(:category, :test).visit(:v1).should == :v1
    end
    
    it "should return nil if variant specified and not selected" do
      a_b(:category, :test).visit(:v1)
      a_b(:category, :test).visit(:v2).should == nil
    end
    
    it "should accept a block and pass the selected variant name to it" do
      ran = false
      a_b(:category, :test).visit do |variant|
        ran = true
        variant.should == :v1
      end
      ran.should == true
    end
    
    it "should accept a block for a specific variant" do
      ran = false
      a_b(:category, :test).visit(:v1) do
        ran = true
      end
      ran.should == true
    end
    
    it "should not call a block for a specific variant if the variant is not selected" do
      ran = false
      a_b(:category, :test).visit(:v2) do
        ran = true
      end
      ran.should == false
    end
    
    it "should accept a hash with extra boolean values" do
      a_b(:category, :test, :e => true).visit(:v1)
      JSON($cookies['a_b_s']).should == {"v"=>[2],"e"=>{"e" => true}}
    end
  end
  
  describe 'convert' do
    
    before(:each) do
      a_b(:category, :test).visit
    end
    
    it "should return the variant name" do
      a_b(:category, :test).convert.should == :v1
    end
    
    it "should return the variant name every time" do
      a_b(:category, :test).convert
      a_b(:category, :test).convert.should == :v1
    end
    
    it "should set cookie" do
      a_b(:category, :test).convert
      JSON($cookies['a_b_s']).should == {"v"=>[2], "c"=>[2]}
    end
    
    it "should maintain state if called more than once" do
      a_b(:category, :test).convert
      a_b(:category, :test).convert
      JSON($cookies['a_b_s']).should == {"v"=>[2], "c"=>[2]}
    end
    
    it "should return the variant name if variant specified and selected" do
      a_b(:category, :test).convert(:v1).should == :v1
    end
    
    it "should return nil if variant specified and not selected" do
      a_b(:category, :test).convert(:v1)
      a_b(:category, :test).convert(:v2).should == nil
    end
    
    it "should accept a block and pass the selected variant name to it" do
      ran = false
      a_b(:category, :test).convert do |variant|
        ran = true
        variant.should == :v1
      end
      ran.should == true
    end
    
    it "should accept a block for a specific variant" do
      ran = false
      a_b(:category, :test).convert(:v1) do
        ran = true
      end
      ran.should == true
    end
    
    it "should not call a block for a specific variant if the variant is not selected" do
      ran = false
      a_b(:category, :test).convert(:v2) do
        ran = true
      end
      ran.should == false
    end
    
    it "should accept a hash with extra boolean values" do
      a_b(:category, :test, :e => true).convert(:v1)
      JSON($cookies['a_b_s']).should == {"v"=>[2],"c"=>[2],"e"=>{"e" => true}}
    end
  end
end