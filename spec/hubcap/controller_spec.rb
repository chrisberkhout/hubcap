require 'hubcap'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'

# http://www.sinatrarb.com/testing.html

describe Hubcap do
  include Capybara
  
  before :all do
    Capybara.app = Sinatra::Application.new
  end

  it "should serve a form for entering github credentials" do
    pending
    visit '/'
    page.should have_content('GitHub login')
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
