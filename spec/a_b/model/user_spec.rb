require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe User do
  
  before(:each) do
    teardown_tests
    setup_tests
  end
  
  describe :associations do
    
    it "should have many categories" do
      @user.categories.empty?.should == false
      @user.categories.should == [ @category ]
    end
    
    it "should destroy categories after destroy" do
      @user.destroy
      Category.count(:conditions => { :user_id => @user.id }).should == 0
    end
    
    it "should have many envs" do
      @user.envs.empty?.should == false
      @user.envs.should == [ @env ]
    end
    
    it "should delete all envs after destroy" do
      @user.destroy
      Env.count(:conditions => { :user_id => @user.id }).should == 0
    end
    
    it "should have many tests" do
      @user.tests.empty?.should == false
      @user.tests.should == [ @test ]
    end
    
    it "should have many variants" do
      @user.variants.empty?.should == false
      @user.variants.should == [ @variant ]
    end
  end
end
