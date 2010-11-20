require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ABTest do
  
  before(:each) do
    teardown_tests
    setup_tests
  end
  
  describe :associations do
    
    it "should belong to a category" do
      @test.category.nil?.should == false
      @test.category.should == @category
    end
    
    it "should belong to a site" do
      @test.site.nil?.should == false
      @test.site.should == @site
    end
    
    it "should belong to a user" do
      @test.user.nil?.should == false
      @test.user.should == @user
    end
    
    it "should have many variants" do
      @test.variants.empty?.should == false
      @test.variants.should == [ @variant ]
    end
    
    it "should destroy variants after destroy" do
      @test.destroy
      Variant.count(:conditions => { :test_id => @test.id }).should == 0
    end
  end
end