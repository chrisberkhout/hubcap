require 'hubcap/github_api'
require_relative '../helpers/fakeweb_helpers'
  
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

    describe "#repos for chrisberkhout" do
      before(:all) do
        @data = fakeweb_chrisberkhout
        @gh = GithubAPI.new(:login => @data[:login], :token => @data[:token])
        @repos = @gh.repos
      end
      it "should return a list of repos" do
        @repos.class.should == Array
        @repos.length.should == 3
        @repos.map{|r| r['name'] }.sort.should == @data[:repo_names].sort
      end
      it "should include public and private repos" do
        privacy_values = @repos.map{ |r| r["private"] }
        privacy_values.include?(true).should be_true
        privacy_values.include?(false).should be_true
      end
    end
      
    describe "#participation for chrisberkhout" do
      before(:all) do
        @data = fakeweb_chrisberkhout
        @gh = GithubAPI.new(:login => @data[:login], :token => @data[:token])
      end
      it "should fetch decoded participation data for a public repo" do
        participation = @gh.participation("hubcap")
        participation.length.should == 52
        participation[-3].should == 3
      end
      it "should fetch correctly decoded participation data for a private repo" do
        participation = @gh.participation("beeswax")
        participation.length.should == 52
        participation[14].should == 1
      end
    end
    
    describe "#repos with bad credentials" do
      before(:all) do
        @data = fakeweb_chrisberkhout_badcredentials
      end
      it "should return nil when given bad login" do
        lambda { GithubAPI.new(:login => @data[:loginwrong]).repos }.should raise_error
        lambda { GithubAPI.new(:login => @data[:loginwrong]).participation('hubcap') }.should raise_error
      end
      it "should return nil when given bad token" do
        lambda { GithubAPI.new(:login => @data[:login]+"badtoken", :token => @data[:badtoken]).repos }.should raise_error
        lambda { GithubAPI.new(:login => @data[:login]+"badtoken", :token => @data[:badtoken]).participation('hubcap') }.should raise_error
      end
      # NOTE: It is currently assumed that the login, token and repo names are
      # correct if the repo names were successfully fetched with that login and token.
    end
    
    describe "#repos for drnic" do
      it "should load a multi-page repo list" do
        @data = fakeweb_drnic
        GithubAPI.new(:login => "drnic").repos.count.should == @data[:repo_count]
      end
    end
  
  end
end
