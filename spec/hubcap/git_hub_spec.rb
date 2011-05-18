require 'hubcap/git_hub'
require 'fakeweb'
  
module Hubcap
  describe GitHub do
    
    LOGIN      = "chrisberkhout"
    TOKEN      = "ef57c2ff4b4a75a2727e90927ebf52eb"
    REPO_NAMES = ["hubcap", "rag_deploy", "beeswax"]

    before(:all) do
      
      FakeWeb.allow_net_connect = false
      
      FakeWeb.register_uri(
        :any, "https://github.com/api/v2/json/repos/show/#{LOGIN}?page=1", 
        :body => File.read("spec/resources/repos_show_#{LOGIN}_1.json")
      )
      
      REPO_NAMES.each do |repo_name|
        FakeWeb.register_uri(
          :any, "https://github.com/#{LOGIN}/#{repo_name}/graphs/participation", 
          :body => File.read("spec/resources/participation_#{LOGIN}_#{repo_name}.base64")
        )
      end
      
    end

    describe "#initialize" do
      it "should be happy if there is a login" do
        lambda { GitHub.new(:login => LOGIN) }.should_not raise_error
      end
      it "should raise an error if the login is not specified" do
        lambda { GitHub.new }.should raise_error
      end
      it "should use the api token if provided" do
        GitHub.new(:login => LOGIN, :token => TOKEN).repos
        FakeWeb.last_request.body.split("&").include?("token=#{TOKEN}").should be_true
      end
      it "should ignore api token if it is empty" do
        GitHub.new(:login => LOGIN, :token => "").repos
        FakeWeb.last_request.body.split("&").include?("token=").should be_false
      end
    end

    describe "#repos for #{LOGIN}" do
      
      before(:all) do
        @repos = GitHub.new(:login => LOGIN, :token => TOKEN).repos
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

    end  
  
  end
end
