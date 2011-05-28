require 'hubcap'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'

# http://www.sinatrarb.com/testing.html

describe Hubcap::Controller do
  include Capybara
  
  before :all do
    Capybara.app = Sinatra::Application.new
  end

  it "should serve a form for entering github credentials" do
    visit '/'
    find_field('GitHub login')
    find_field('GitHub API token')
  end
  
  context "with bad github credentials" do
    # at this point, factor out the fakeweb cases into a helper
    it "should return a message" do
      pending
    end
  end
  context "with good github credentials" do
    it "should render the report" do
      pending
    end
  end
  
end
