require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require_relative '../helpers/fakeweb_helpers'

describe "GitHub API (unofficial)" do

  it "should return participation data in the expected json format" do
    fakeweb_disable
    schema = {
      "type" => "object",
      "properties" => {
        "all" => { 
          "required" => true,
          "type" => "array",
          "minItems" => 52,
          "maxItems" => 52,
          "items" => [{ "type" => "integer" }]
        },
        "owner" => { 
          "required" => true,
          "type" => "array",
          "minItems" => 52,
          "maxItems" => 52,
          "items" => [{ "type" => "integer" }]
        }
      }
    }
    body = live_api_get_body('/chrisberkhout/hubcap/graphs/participation')
    JSON::Validator.validate!(schema, body)
  end
  
  # NOTE: I intended to spec the limit for how many repos you can get 
  #       participation data for before a timeout is enforced. However, on
  #       closer inspection, the limit I'd previously observed (20 repos)
  #       turned out to be unreliable.
  
end
