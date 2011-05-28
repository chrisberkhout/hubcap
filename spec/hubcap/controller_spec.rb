require 'hubcap'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'spec/helpers/fakeweb_helpers'
require 'ruby-debug'

describe "Sinatra controller.rb" do
  include Capybara
  
  before :all do
    Capybara.app = Sinatra::Application.new
    @data = fakeweb_chrisberkhout
  end

  it "should serve a form for entering github credentials" do
    visit '/'
    find_field 'GitHub login'
    find_field 'GitHub API token'
  end
  
  context "with bad github credentials" do
    before :all do
      visit '/'
      fill_in 'GitHub login', :with => @data[:login]+"wrong"
      fill_in 'GitHub API token', :with => @data[:token]+"wrong"
      find_button('user_submit').click
    end
    it "should return a message" do
      page.current_path.should == "/"
      find_field 'GitHub login'
      find_field 'GitHub API token'
      page.should have_content("error")
    end
  end
  
  context "with good github credentials" do
    before :all do
      visit '/'
      fill_in 'GitHub login', :with => @data[:login]
      fill_in 'GitHub API token', :with => @data[:token]
      find_button('user_submit').click
    end
    it "should render the report" do
      page.should have_css("div.chart")
    end
  end
  
end
