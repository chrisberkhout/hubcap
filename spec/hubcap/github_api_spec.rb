require 'hubcap/github_api'
require 'spec/helpers/fakeweb_helpers'
  
module Hubcap
  describe GithubAPI do

    describe "#initialize" do
      before(:all) do
        @data = fakeweb_chrisberkhout
      end

      it "should be happy if there is a login" do
        lambda { GithubAPI.new(:login => @data[:login]) }.should_not raise_error
      end
      it "should raise an error if the login is not specified" do
        lambda { GithubAPI.new }.should raise_error
      end
      it "should use the API token if provided" do
        GithubAPI.new(:login => @data[:login], :token => @data[:token]).repos
        FakeWeb.last_request.body.split("&").include?("token=#{@data[:token]}").should be_true
      end
      it "should ignore API token if it is empty" do
        GithubAPI.new(:login => @data[:login], :token => "").repos
        FakeWeb.last_request.body.split("&").include?("token=").should be_false
      end
    end

    describe "#repos* for chrisberkhout" do
      before(:all) do
        @data = fakeweb_chrisberkhout
        @gh = GithubAPI.new(:login => @data[:login], :token => @data[:token])
        @repos_with_participation = @gh.repos_with_participation
      end
      
      it "should return a list of repos" do
        @repos_with_participation.class.should == Array
        @repos_with_participation.length.should == 3
        @repos_with_participation.map{|r| r['name'] }.sort.should == @data[:repo_names].sort
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
      
      it "should cache the repos and not attempt to refetch them every time #repos is called" do
        fakeweb_init
        old_request = FakeWeb.last_request
        @gh.repos
        FakeWeb.last_request.object_id.should == old_request.object_id
      end
    end
    
    describe "#repos* for bad credentials" do
      before(:all) do
        @data = fakeweb_chrisberkhout_badcredentials
      end
      it "should return nil when given bad login" do
        GithubAPI.new(:login => @data[:loginwrong]).repos.should be_nil
        GithubAPI.new(:login => @data[:loginwrong]).repos_with_participation.should be_nil
      end
      it "should return nil when given bad token" do
        GithubAPI.new(:login => @data[:login]+"badtoken", :token => @data[:badtoken]).repos.should be_nil
        GithubAPI.new(:login => @data[:login]+"badtoken", :token => @data[:badtoken]).repos_with_participation.should be_nil
      end
      # NOTE: It is currently assumed that the login, token and repo names are
      # correct if the repo names were successfully fetched with that login and token.
    end
    
    describe "#repos* for drnic" do
      before(:each) do
        @data = fakeweb_drnic
      end

      it "should load a multi-page repo list" do
        GithubAPI.new(:login => "drnic").repos.count.should == @data[:repo_count]
      end
      
      it "should get participation data for a maximum of 20 repos" do
        GithubAPI.new(:login => "drnic").repos_with_participation.count.should == 20
      end

      it "should get participation data for the 20 repos most recently pushed to" do
        GithubAPI.new(:login => "drnic").repos_with_participation.map{|r| r['name'] }.sort.should == @data[:most_recently_pushed].sort
      end
    end

    describe "#repos* for drnic (limited)" do
      before(:each) do
        @data = fakeweb_drnic(:limit_to => 16)
      end
      it "should successfully return participation data when GithubAPI limits it to less than 20 repos" do
        GithubAPI.new(:login => "drnic").repos_with_participation.map{|r| r['name'] }.sort.should == @data[:most_recently_pushed][0..15].sort
      end
    end  
  
  end
end
