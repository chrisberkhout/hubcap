require 'hubcap'
require 'rack/test'

set :environment, :test

# http://www.sinatrarb.com/testing.html

describe Hubcap do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "Serves login page" do
    get '/'
    last_response.should be_ok
    last_response.body[/GitHub login/].should be_true
  end
end
