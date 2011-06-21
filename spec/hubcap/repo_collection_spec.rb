require 'hubcap/repo_collection'
require 'spec/helpers/fakeweb_helpers'
  
module Hubcap
  describe RepoCollection do
    
    describe "#initialize" do
      it "should return with an object containing data on repos" do
        @data = fakeweb_chrisberkhout
        lambda { @repos = RepoCollection.new(:login => @data[:login], :token => @data[:token]) }.should_not raise_error
        @repos.length.should == 3
        @repos.each{ |repo| repo.class.should == Repo }
      end
      
      context "with drnic's login" do
        it "should get participation data for a maximum of 20 repos" do
          fakeweb_drnic
          gh = GithubAPI.new(:login => "drnic")
          gh.should_receive(:participation).at_most(20).times
          GithubAPI.should_receive(:new).and_return(gh)
          RepoCollection.new(:login => 'drnic')
        end
        it "should get participation data for the 20 repos most recently pushed to" do
          data = fakeweb_drnic
          RepoCollection.new(:login => 'drnic').with_participation.map{|r| r['name'] }.sort.should == data[:most_recently_pushed].sort
        end
        it "should successfully return participation data when GithubAPI limits it to less than 20 repos" do
          data = fakeweb_drnic(:limit_to => 16)
          RepoCollection.new(:login => 'drnic').with_participation.map{|r| r['name'] }.sort.should == data[:most_recently_pushed][0..15].sort
        end
      end
      
      it "should set colours" do
        data = fakeweb_chrisberkhout
        repos = RepoCollection.new(:login => data[:login], :token => data[:token])
        repos.with_participation.count.should > 0
        repos.without_participation.each do |repo|
          repo["color"].should_not be_nil
        end
      end
    end
    
    describe "sort and selection methods" do
      describe "(#by_last_pushed_desc)" do
        it "should work" do
          pending
        end
      end

      describe "(#by_first_commit_then_last_commit)" do
        it "should work" do
          pending
        end
      end

      describe "(#with_participation)" do
        it "should work" do
          pending
        end
      end

      describe "(#without_participation)" do
        it "should work" do
          pending
        end
      end
      
      it "should be chainable" do
        pending
      end
    end
  
  end
end
