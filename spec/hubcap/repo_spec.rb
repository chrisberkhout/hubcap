require 'hubcap/repo'
  
module Hubcap
  describe Repo do

    describe "#initialize" do
      it "should merge in the hash passed to it" do
        pending
      end
    end
    
    describe "[first|last]_commit_week" do
      it "should ensure that there is valid participation data" do
        pending
      end

      it "should return the index of the first week with a commit" do
        pending
      end

      it "should return the index of the last week with a commit" do
        pending
      end

      it "should both return the last index plus one if there are no commits" do
        pending
      end
      
      it "should be useful for sorting in 'first commit then first finished, empty last' order" do
        pending
      end
    end
  
  end
end
