require "hubcap/hub_stats"

module Hubcap
  
  describe HubStats do

    describe "#initialize" do
      it "should be happy if there is a username" do
        lambda { HubStats.new(:username => 'chrisberkhout') }.should_not raise_error
      end
      it "should raise an error if the username is not specified" do
        lambda { HubStats.new }.should raise_error
      end
    end
    
  
  end

end