require 'hubcap/repo'
  
module Hubcap
  describe Repo do

    describe "#initialize" do
      it "should merge in the hash passed to it" do
        Repo.new({:mykey => "myval"}).keys.should include :mykey
      end
    end

    describe "#pushed_or_created_at" do
      it "should return pushed_at if present, otherwise created_at" do
        Repo.new({ "created_at" => "2010/12/26 22:17:59 -0800" }).pushed_or_created_at.should == "2010/12/26 22:17:59 -0800"
        Repo.new({ "created_at" => "2010/12/07 14:55:46 -0800", "pushed_at" => "2010/12/12 21:51:31 -0800" }).pushed_or_created_at.should == "2010/12/12 21:51:31 -0800"
      end
    end
    
    describe "[first|last]_commit_week" do
      it "should ensure that there is valid participation data" do
        lambda { Repo.new({}).first_commit_week }.should raise_error
        lambda { Repo.new({}).last_commit_week }.should raise_error
      end

      context "with participation data with commits" do
        before :all do
          @repo = Repo.new({"participation" => [0,0,0,0,0,2,0,3,0,0,0,0,0,5,1,1,3,0,0,0,0,0,0,0,1,2,0,0,7,0,4,0,0,0,0,0,0,0,4,0,0,9,3,5,0,0,0,0,0,2,1,0]})
        end
        
        it "should return the index of the first week with a commit" do
          @repo.first_commit_week.should == 5
        end

        it "should return the index of the last week with a commit" do
          @repo.last_commit_week.should == 50
        end
      end

      context "with participation data with no commits" do
        it "should both return the last index plus one if there are no commits" do
          r = Repo.new({"participation" => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]})
          r.first_commit_week.should == 52
          r.last_commit_week.should == 52
        end
      end
      
      it "should be useful for sorting in 'first commit then first finished, empty last' order" do
        repos = [                                                                                             
          Repo.new({ "name" => "repo1", "participation" => [0,0,1,1,1,0,0,0,0,0,0,0] }),
          Repo.new({ "name" => "repo2", "participation" => [0,0,0,0,0,0,0,0,0,0,0,0] }),
          Repo.new({ "name" => "repo3", "participation" => [0,0,1,1,1,1,0,0,0,0,0,0] }),
          Repo.new({ "name" => "repo4", "participation" => [0,0,0,0,1,0,0,1,0,0,0,0] })
        ]
        repos.sort_by{ |r| [r.first_commit_week, r.last_commit_week] }.map{ |r| r["name"] }.should == ["repo1", "repo3", "repo4", "repo2"]
      end
    end
  
  end
end
