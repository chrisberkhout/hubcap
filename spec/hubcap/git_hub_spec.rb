require 'hubcap/git_hub'
require 'fakeweb'
require 'spec/helpers/fakeweb_helpers'
  
module Hubcap
  describe GitHub do
    
    before(:all) do
      @fw = fakeweb_chrisberkhout
    end

    describe "#initialize" do
      it "should be happy if there is a login" do
        lambda { GitHub.new(:login => @fw[:login]) }.should_not raise_error
      end
      it "should raise an error if the login is not specified" do
        lambda { GitHub.new }.should raise_error
      end
      it "should use the api token if provided" do
        GitHub.new(:login => @fw[:login], :token => @fw[:token]).repos
        FakeWeb.last_request.body.split("&").include?("token=#{@fw[:token]}").should be_true
      end
      it "should ignore api token if it is empty" do
        GitHub.new(:login => @fw[:login], :token => "").repos
        FakeWeb.last_request.body.split("&").include?("token=").should be_false
      end
    end

    describe "#repos for chrisberkhout" do
      
      before(:all) do
        @repos_with_participation = GitHub.new(:login => @fw[:login], :token => @fw[:token]).repos_with_participation
      end
      
      it "should return a list of repos" do
        @repos_with_participation.class.should == Array
        @repos_with_participation.length.should == 3
        @repos_with_participation.map{|r| r['name'] }.sort.should == @fw[:repo_names].sort
      end
      
      it "should include public and private repos" do
        privacy_values = @repos_with_participation.map{ |r| r["private"] }
        privacy_values.include?(true).should be_true
        privacy_values.include?(false).should be_true
      end
      
      it "should include correctly decoded participation data for public repos" do
        @repos_with_participation.select{ |r| r['name'] == "hubcap" }.first["participation"].length.should == 52
        @repos_with_participation.select{ |r| r['name'] == "hubcap" }.first["participation"][-1].should == 3
      end
      
      it "should include correctly decoded participation data for private repos" do
        @repos_with_participation.select{ |r| r['name'] == "beeswax" }.first["participation"].length.should == 52
        @repos_with_participation.select{ |r| r['name'] == "beeswax" }.first["participation"][14].should == 1
      end
      
    end
    
    describe "#repos for drnic" do
      
      before(:all) do
        FakeWeb.register_uri(
          :any, "https://github.com/api/v2/json/repos/show/drnic?page=1", 
          :body => File.read("spec/resources/repos_show_drnic_1.json"),
          :x_next => "https://github.com/api/v2/json/repos/show/drnic?page=2"
        )
        
        FakeWeb.register_uri(
          :any, "https://github.com/api/v2/json/repos/show/drnic?page=2", 
          :body => File.read("spec/resources/repos_show_drnic_2.json")
        )
        
        FakeWeb.register_uri(
          :any, %r|https\://github\.com/drnic/.*?/graphs/participation|, 
          :body => File.read("spec/resources/participation_drnic_all.base64")
        )
      end

      it "should load a multi-page repo list" do
        GitHub.new(:login => "drnic").repos.count.should == 168
      end
      
      it "should only get participation data for 20 repos" do
        GitHub.new(:login => "drnic").repos_with_participation.count.should == 20
      end

      it "should get participation data for the 20 repos most recently pushed to" do
        GitHub.new(:login => "drnic").repos_with_participation.map{|r| r['name'] }.sort.should == ["FakeWeb.tmbundle", "em-synchrony", "sinatra-synchrony", "sinatra-synchrony-example", "rails_wizard.web", ".dotfiles", "redcar", "red-dirt-workers-tutorial", "svruby-awards", "queue_classic", "test_edge_rails", "magic_multi_connections", "ci_demo_app", "rubigen", "tabtab", "todolist-webinar", "todolist-app", "composite_primary_keys", "docrails", "grape_test_app"].sort
      end

    end  
  
  end
end
