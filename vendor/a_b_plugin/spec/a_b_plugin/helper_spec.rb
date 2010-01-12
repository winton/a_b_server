require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module ABPlugin
  
  class HelperInstance
    include Helper
  end
  
  module Helper
    
    describe ABPlugin::Helper do
      
      describe :a_b_convert do

        before(:each) do
          stub_api_boot
          ABPlugin.stub!(:active?).and_return(true)
          ABPlugin.tests = @tests
          @instance = ABPlugin::HelperInstance.new
        end
        
        it "should call a block if selected" do
          block_ran = false
          @instance.send(:a_b_convert, 'Test') { block_ran = true }
          block_ran.should == true
        end

        it "should add an entry to the conversions and visits hash if selected (given a test)" do
          @instance.send(:a_b_convert, 'Test')
          @instance.instance_eval do
            @a_b_conversions.should == { "Test" => "v1" }
            @a_b_visits.should == { "Test" => "v1" }
          end
        end
        
        it "should add an entry to the conversions and visits hash if selected (given a variant)" do
          @instance.send(:a_b_convert, 'v1')
          @instance.instance_eval do
            @a_b_conversions.should == { "Test" => "v1" }
            @a_b_visits.should == { "Test" => "v1" }
          end
        end
      end
      
      describe :a_b_visit do

        before(:each) do
          stub_api_boot
          ABPlugin.stub!(:active?).and_return(true)
          ABPlugin.tests = @tests
          @instance = ABPlugin::HelperInstance.new
        end
        
        it "should call a block if selected" do
          block_ran = false
          @instance.send(:a_b_visit, 'Test') { block_ran = true }
          block_ran.should == true
        end

        it "should add an entry to the visits hash if selected (given a test)" do
          @instance.send(:a_b_visit, 'Test')
          @instance.instance_eval do
            @a_b_conversions.should == nil
            @a_b_visits.should == { "Test" => "v1" }
          end
        end
        
        it "should add an entry to the visits hash if selected (given a variant)" do
          @instance.send(:a_b_visit, 'v1')
          @instance.instance_eval do
            @a_b_conversions.should == nil
            @a_b_visits.should == { "Test" => "v1" }
          end
        end
      end
      
      describe :a_b_script_tag do
        
        before(:each) do
          stub_api_boot
          ABPlugin.stub!(:active?).and_return(true)
          ABPlugin.session_id = @session_id
          ABPlugin.tests = @tests
          ABPlugin.token = @token
          ABPlugin.user_token = @user_token
          ABPlugin.url = @url
          @instance = ABPlugin::HelperInstance.new
          @instance.send(:a_b_convert, 'Test')
          @js = @instance.send(:a_b_script_tag, '/js/ab.js')
          @setup_params = JSON[/<script.+>A_B.setup\((.+)\);<\/script>/.match(@js)[1]]
        end
        
        it "should include the passed javascript path parameter" do
          @js.include?("<script src='/js/ab.js' type='text/javascript'></script>").should == true
        end
        
        it "should call A_B.config with the correct parameters" do
          conversions = nil
          visits = nil
          @instance.instance_eval do
            conversions = @a_b_conversions
            visits = @a_b_visits
          end
          @setup_params.should == {
            "conversions" => conversions,
            "session_id" => @session_id,
            "tests" => @tests,
            "token" => Digest::SHA256.hexdigest(@session_id + @user_token),
            "url" => @url,
            "visits" => visits
          }
        end
      end
    end
  end
end
