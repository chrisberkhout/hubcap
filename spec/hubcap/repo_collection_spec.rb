require 'hubcap/repo_collection'
require_relative '../helpers/fakeweb_helpers'
  
module Hubcap
  describe RepoCollection do
    
    describe "#initialize" do
      it "should return with an object containing data on repos" do
        @data = fakeweb_chrisberkhout
        lambda { @repos = RepoCollection.new(:login => @data[:login], :token => @data[:token]) }.should_not raise_error
        @repos.length.should == 3
        @repos.each{ |repo| repo.class.should == Repo }
      end
      
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
      before(:all) do
        @data = fakeweb_chrisberkhout
        @repos = RepoCollection.new(:login => @data[:login], :token => @data[:token])
      end
      it "should return #by_last_pushed_desc" do
        @repos.by_last_pushed_desc.map{|r| r["name"]}.should == @data[:last_pushed_desc]
      end

      it "should return #by_first_commit_then_last_commit" do
        @repos.by_first_commit_then_last_commit.map{|r| r["name"]}.should == @data[:first_commit_then_last_commit]
      end
    end

    describe "sort and selection methods" do
      before(:all) do
        @data = fakeweb_drnic
        @repos = RepoCollection.new(:login => 'drnic')
      end
      it "should return #with_participation" do
        @repos.with_participation.count.should == 20
        @repos.with_participation.each do |repo|
          repo["participation"].should_not be_nil
        end
      end
      it "should return #without_participation" do
        @repos.without_participation.count.should == 148
        @repos.without_participation.each do |repo|
          repo["participation"].should be_nil
        end
      end
      it "should be chainable" do
        by_last_pushed_desc = ["FakeWeb.tmbundle", "em-synchrony", "sinatra-synchrony", "sinatra-synchrony-example", "rails_wizard.web", ".dotfiles", "redcar", "red-dirt-workers-tutorial", "svruby-awards", "queue_classic", "test_edge_rails", "magic_multi_connections", "ci_demo_app", "rubigen", "tabtab", "todolist-webinar", "todolist-app", "composite_primary_keys", "docrails", "grape_test_app"]
        by_first_commit_then_last_commit = [".dotfiles", "ci_demo_app", "composite_primary_keys", "docrails", "em-synchrony", "FakeWeb.tmbundle", "grape_test_app", "magic_multi_connections", "queue_classic", "rails_wizard.web", "red-dirt-workers-tutorial", "redcar", "rubigen", "sinatra-synchrony", "sinatra-synchrony-example", "svruby-awards", "tabtab", "test_edge_rails", "todolist-app", "todolist-webinar"]
        by_last_pushed_desc.should_not == by_first_commit_then_last_commit
        by_last_pushed_desc.sort.should == by_first_commit_then_last_commit.sort
        @repos.by_last_pushed_desc.with_participation.map{|r| r["name"]}.should == by_last_pushed_desc
        @repos.with_participation.by_first_commit_then_last_commit.map{|r| r["name"]}.should == by_first_commit_then_last_commit
      end
    end
  
    describe "#weeks_of_full_data" do
      it "should give the number of weeks with full data" do
        pending "Not sure if this regressed. Check correct result."
        fakeweb_drnic
        repos = RepoCollection.new(:login => 'drnic')
        repos.weeks_of_full_data.should == 18
      end
    end
    describe "#weeks_of_partial_data" do
      it "should give the number of weeks with partial data" do
        fakeweb_drnic
        repos = RepoCollection.new(:login => 'drnic')
        repos.weeks_of_partial_data.should == 52 - repos.weeks_of_full_data
      end
      it "should never give weeks of partial data as a negative" do
        fakeweb_drnic
        repos = RepoCollection.new(:login => 'drnic')
        repos.stub(:weeks_of_full_data) { 112 }
        repos.weeks_of_partial_data.should == 0
      end
      it "should not say data is partial if there are no repos without participation" do
        fakeweb_drnic
        repos = RepoCollection.new(:login => 'drnic')
        repos.stub(:weeks_of_full_data) { 45 }
        repos.stub(:without_participation) { mock(:count => 0) }
        repos.weeks_of_partial_data.should == 0
      end
    end
  
  end
end
