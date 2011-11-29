require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require_relative '../helpers/fakeweb_helpers'

describe "GitHub API (unofficial)" do

  it "should return participation data in the expected Base64 encoding" do
    fakeweb_disable
    lines = live_api_get_body("/chrisberkhout/hubcap/graphs/participation").split("\n")
    lines.length.should == 2
    lines.each do |line|
      line.should match(/[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!-]{104}/)
    end
  end
  
  # NOTE: I intended to spec the limit for how many repos you can get 
  #       participation data for before a timeout is enforced. However, on
  #       closer inspection, the limit I'd previously observed (20 repos)
  #       turned out to be unreliable.
  
end
