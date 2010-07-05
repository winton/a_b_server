require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Category do
  
  before(:each) do
    teardown_tests
    setup_tests
  end
  
  describe :associations do
    
    it "should belong to a site" do
      @category.site.nil?.should == false
      @category.site.should == @site
    end
    
    it "should have many tests" do
      @category.tests.empty?.should == false
      @category.tests.should == [ @test ]
    end
    
    it "should belong to a user" do
      @category.user.nil?.should == false
      @category.user.should == @user
    end
    
    it "should destroy tests after destroy" do
      @category.destroy
      ABTest.count(:conditions => { :category_id => @category.id }).should == 0
    end
    
    it "should have many variants" do
      @category.variants.empty?.should == false
      @category.variants.should == [ @variant ]
    end
  end
end