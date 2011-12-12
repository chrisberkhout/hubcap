require './hubcap'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require_relative '../helpers/fakeweb_helpers'

describe "Sinatra controller.rb" do
  include Capybara
  
  before :all do
    Capybara.app = Sinatra::Application.new
  end

  it "should serve a form for entering github credentials" do
    @data = fakeweb_chrisberkhout
    visit '/'
    find_field 'GitHub login'
    find_field 'Optional API token'
  end
  
  context "with bad github credentials" do
    before :all do
      @data = fakeweb_chrisberkhout
      visit '/'
      fill_in 'GitHub login', :with => @data[:login]+"wrong"
      fill_in 'Optional API token', :with => @data[:token]+"wrong"
      find_button('user_submit').click
    end
    it "should return a message" do
      page.current_path.should == "/"
      find_field 'GitHub login'
      find_field 'Optional API token'
      page.should have_content("error")
    end
  end
  
  context "with a good github login (no token)" do
    before :all do
      @data = fakeweb_chrisberkhout
      visit '/'
      fill_in 'GitHub login', :with => @data[:login]
      find_button('user_submit').click
    end
    it "should render the report" do
      page.should have_css("div#chart")
    end
    it "should redirect to a path for the given login" do
      page.current_path.should == "/#{@data[:login]}"
    end
  end

  context "with a good github login and token" do
    before :all do
      @data = fakeweb_chrisberkhout
      visit '/'
      fill_in 'GitHub login', :with => @data[:login]
      fill_in 'Optional API token', :with => @data[:token]
      find_button('user_submit').click
    end
    it "should render the report" do
      page.should have_css("div#chart")
    end
    it "should not redirect to a path for the given login" do
      page.current_path.should == "/"
    end
  end

  context "for a login with no repositories" do
    before :all do
      @data = fakeweb_login
      visit '/'
      fill_in 'GitHub login', :with => @data[:login]
      find_button('user_submit').click
    end
    it "should render the report gracefully" do
      page.should have_css("div#chart")
    end
  end
  
end
