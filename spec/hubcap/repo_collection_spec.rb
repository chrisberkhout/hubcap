require 'hubcap/repo_collection'
  
module Hubcap
  describe RepoCollection do
    
    describe "#initialize" do
      it "should return with an object containing data on repos" do
        pending
      end

      context "with drnic's login" do
        it "should get participation data for a maximum of 20 repos" do
          pending
          GithubAPI.new(:login => "drnic").repos_with_participation.count.should == 20
        end
        it "should get participation data for the 20 repos most recently pushed to" do
          pending
          GithubAPI.new(:login => "drnic").repos_with_participation.map{|r| r['name'] }.sort.should == @data[:most_recently_pushed].sort
        end
        it "should successfully return participation data when GithubAPI limits it to less than 20 repos" do
          pending
          @data = fakeweb_drnic(:limit_to => 16)
          GithubAPI.new(:login => "drnic").repos_with_participation.map{|r| r['name'] }.sort.should == @data[:most_recently_pushed][0..15].sort
        end
      end
      
      it "should set colours" do
        pending
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
