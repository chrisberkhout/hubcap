require 'hubcap/hub_stats'
require 'fakeweb'
# require 'ruby-debug'
  
module Hubcap
  describe HubStats do
    
    before do
      @username = "chrisberkhout"
      @token    = "ef57c2ff4b4a75a2727e90927ebf52eb"
      FakeWeb.allow_net_connect = false
      FakeWeb.register_uri(
        :any, "http://github.com/api/v2/json/repos/show/#{@username}", 
        :body => File.read("spec/resources/repo_list.json")
      )
    end

    describe "#initialize" do
      it "should be happy if there is a username" do
        lambda { HubStats.new(:username => @username) }.should_not raise_error
      end
      it "should raise an error if the username is not specified" do
        lambda { HubStats.new }.should raise_error
      end
      it "should use the api token if provided" do
        HubStats.new(:username => @username, :token => @token)
        FakeWeb.last_request.body.split("&").include?("token=#{@token}").should be_true
      end
    end

    describe "#repos" do
      it "should return a list of repos" do
        pending
        repos = HubStats.new(:username => @username, :token => @token).repos
        repos.class.should == Hash
        repos.length.should == 3
        repos.keys.sort.should == ["hubcap", "rag_deploy", "beeswax"]
      end
    end
  
  end
end
