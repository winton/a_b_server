require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Variant do
  
  before(:each) do
    $cached_find = nil
    teardown_tests
    setup_tests
  end
  
  describe :associations do
    
    it "should belong to a category" do
      @variant.category.nil?.should == false
      @variant.category.should == @category
    end
    
    it "should belong to a site" do
      @variant.site.nil?.should == false
      @variant.site.should == @site
    end
    
    it "should belong to a test" do
      @variant.test.nil?.should == false
      @variant.test.should == @test
    end
    
    it "should belong to a user" do
      @variant.user.nil?.should == false
      @variant.user.should == @user
    end
  end
  
  describe :record do
    
    before(:each) do
      @data = { 'v' => [ 1 ], 'c' => [ 1 ], 'e' => { 'e1' => true }}
      @ids = Variant.record(
        :env => 'env',
        :data => @data,
        :referer => 'http://a.site.com:8888'
      )
    end
    
    it "should return visit and conversion ids" do
      @ids.should == [ [ 1 ], [ 1 ] ]
    end
    
    it "should create a record" do
      v = Variant.last
      v.name.should == "variant"
      v.control.should == false
      v.data.should == {
        "env" => {
          :visit_conditions => { "e1" => 1 },
          :conversion_conditions => { "e1" => 1 },
          :visits => 1,
          :conversions => 1
        }
      }
      v.category_id.should == 1
      v.test_id.should == 1
      v.user_id.should == 1
    end
    
    it "should increment a record" do
      Variant.record(
        :env => 'env',
        :data => @data,
        :referer => 'http://a.site.com:8888'
      )
      v = Variant.last
      v.name.should == "variant"
      v.control.should == false
      v.data.should == {
        "env" => {
          :visit_conditions => { "e1" => 2 },
          :conversion_conditions => { "e1" => 2 },
          :visits => 2,
          :conversions => 2
        }
      }
      v.category_id.should == 1
      v.test_id.should == 1
      v.user_id.should == 1
    end
    
    it "should do nothing if env does not exist" do
      Variant.record(
        :env => 'does_not_exist',
        :data => @data,
        :referer => 'http://a.site.com:8888'
      ).should == [ [], [] ]
    end
  end
end