require 'hubcap/hub_stats'
require 'fakeweb'
require 'ruby-debug'
  
module Hubcap
  describe HubStats do
    
    USERNAME   = "chrisberkhout"
    TOKEN      = "ef57c2ff4b4a75a2727e90927ebf52eb"
    REPO_NAMES = ["hubcap", "rag_deploy", "beeswax"]

    before(:all) do
      
      FakeWeb.allow_net_connect = false
      
      FakeWeb.register_uri(
        :any, "http://github.com:443/api/v2/json/repos/show/#{USERNAME}?page=1", 
        :body => File.read("spec/resources/repos_show_#{USERNAME}_1.json")
      )
      
      REPO_NAMES.each do |repo_name|
        FakeWeb.register_uri(
          :any, "http://github.com:443/#{USERNAME}/#{repo_name}/graphs/participation", 
          :body => File.read("spec/resources/participation_#{USERNAME}_#{repo_name}.base64")
        )
      end
      
    end

    describe "#initialize" do
      it "should be happy if there is a username" do
        lambda { HubStats.new(:username => USERNAME) }.should_not raise_error
      end
      it "should raise an error if the username is not specified" do
        lambda { HubStats.new }.should raise_error
      end
      it "should use the api token if provided" do
        HubStats.new(:username => USERNAME, :token => TOKEN)
        FakeWeb.last_request.body.split("&").include?("token=#{TOKEN}").should be_true
      end
    end

    describe "#repos for #{USERNAME}" do
      
      before(:all) do
        @repos = HubStats.new(:username => USERNAME, :token => TOKEN).repos
      end
      
      it "should return a list of repos" do
        @repos.class.should == Hash
        @repos.length.should == 3
        @repos.keys.sort.should == REPO_NAMES.sort
      end
      
      it "should include public and private repos" do
        privacy_values = @repos.values.map{ |r| r["private"] }
        privacy_values.include?(true).should be_true
        privacy_values.include?(false).should be_true
      end
      
      it "should include participation data for public repos" do
        @repos["hubcap"]["participation"].length.should == 52
        @repos["hubcap"]["participation"][-1].should == 3
      end
      
      it "should include participation data for private repos" do
        @repos["beeswax"]["participation"].length.should == 52
        @repos["beeswax"]["participation"][14].should == 1
      end
      
    end
    
    describe "#repos for drnic" do
      
      before(:all) do
        
        FakeWeb.register_uri(
          :any, "http://github.com:443/api/v2/json/repos/show/drnic?page=1", 
          :body => File.read("spec/resources/repos_show_drnic_1.json"),
          :x_next => "https://github.com/api/v2/json/repos/show/drnic?page=2"
        )
        
        FakeWeb.register_uri(
          :any, "http://github.com:443/api/v2/json/repos/show/drnic?page=2", 
          :body => File.read("spec/resources/repos_show_drnic_2.json")
        )
        
        FakeWeb.register_uri(
          :any, %r|http\://github\.com\:443/drnic/.*?/graphs/participation|, 
          :body => File.read("spec/resources/participation_drnic_all.base64")
        )
        
      end

      it "should load a multi-page repo list" do
        HubStats.new(:username => "drnic").repos.count.should == 168
      end

    end  
  
  end
end
