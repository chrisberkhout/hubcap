require 'hubcap'
require 'capybara'
require 'capybara/dsl'

# http://www.sinatrarb.com/testing.html

describe Hubcap do
  include Capybara
  
  before :all do
    Capybara.app = Sinatra::Application.new
  end

  it "should serve login page" do
    visit '/'
    page.should have_content('GitHub login')
  end
  
end
