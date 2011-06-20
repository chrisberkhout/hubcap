require 'hubcap/repo_collection'
  
module Hubcap
  describe RepoCollection do
    
    it "FOR DRNIC - should get participation data for a maximum of 20 repos" do
      pending
      GithubAPI.new(:login => "drnic").repos_with_participation.count.should == 20
    end

    it "FOR DRNIC - should get participation data for the 20 repos most recently pushed to" do
      pending
      GithubAPI.new(:login => "drnic").repos_with_participation.map{|r| r['name'] }.sort.should == @data[:most_recently_pushed].sort
    end

    describe "#repos* for drnic (limited)" do
      before(:each) do
        @data = fakeweb_drnic(:limit_to => 16)
      end
      it "should successfully return participation data when GithubAPI limits it to less than 20 repos" do
        pending
        GithubAPI.new(:login => "drnic").repos_with_participation.map{|r| r['name'] }.sort.should == @data[:most_recently_pushed][0..15].sort
      end
    end  

  
  end
end
