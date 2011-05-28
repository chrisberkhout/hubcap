require 'hubcap/git_hub'
require 'fakeweb'
require 'spec/helpers/fakeweb_helpers'
  
module Hubcap
  describe GitHub do

    describe "#initialize" do
      before(:all) do
        @data = fakeweb_chrisberkhout
      end

      it "should be happy if there is a login" do
        lambda { GitHub.new(:login => @data[:login]) }.should_not raise_error
      end
      it "should raise an error if the login is not specified" do
        lambda { GitHub.new }.should raise_error
      end
      it "should use the API token if provided" do
        GitHub.new(:login => @data[:login], :token => @data[:token]).repos
        FakeWeb.last_request.body.split("&").include?("token=#{@data[:token]}").should be_true
      end
      it "should ignore API token if it is empty" do
        GitHub.new(:login => @data[:login], :token => "").repos
        FakeWeb.last_request.body.split("&").include?("token=").should be_false
      end
    end

    describe "#repos for chrisberkhout" do
      before(:all) do
        @data = fakeweb_chrisberkhout
        @repos_with_participation = GitHub.new(:login => @data[:login], :token => @data[:token]).repos_with_participation
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
    end
    
    describe "#repos for drnic" do
      before(:all) do
        @data = fakeweb_drnic
      end

      it "should load a multi-page repo list" do
        GitHub.new(:login => "drnic").repos.count.should == @data[:repo_count]
      end
      
      it "should only get participation data for 20 repos" do
        GitHub.new(:login => "drnic").repos_with_participation.count.should == 20
      end

      it "should get participation data for the 20 repos most recently pushed to" do
        GitHub.new(:login => "drnic").repos_with_participation.map{|r| r['name'] }.sort.should == @data[:most_recently_pushed].sort
      end
    end  
  
  end
end
