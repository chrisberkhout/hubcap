require 'json-schema'
require 'spec/helpers/live_api_helper'

describe "GitHub API (v2)" do
  
  before :all do
    @schema = {
      "type" => "object",
      "properties" => {
        "repositories" => { 
          "type" => "array",
          "minItems" => 1,
          "items" => [{
            "type" => "object",
            "properties" => {
              "homepage" => { "type" => "string", "required" => true },
              "watchers" => { "type" => "integer", "required" => true },
              "has_wiki" => { "type" => "boolean", "required" => true },
              "url" => { "type" => "string", "required" => true },
              "forks" => { "type" => "integer", "required" => true },
              "open_issues" => { "type" => "integer", "required" => true },
              "fork" => { "type" => "boolean", "required" => true },
              "has_issues" => { "type" => "boolean", "required" => true },
              "created_at" => { "type" => "string", "pattern" => %r|^\d{4}/\d\d/\d\d \d\d:\d\d:\d\d|, "required" => true },
              "pushed_at" => { "type" => "string", "pattern" => %r|^\d{4}/\d\d/\d\d \d\d:\d\d:\d\d|, "required" => true },
              "description" => { "type" => "string", "required" => true },
              "size" => { "type" => "integer", "required" => true },
              "private" => { "type" => "boolean", "required" => true },
              "name" => { "type" => "string", "required" => true },
              "owner" => { "type" => "string", "required" => true },
              "has_downloads" => { "type" => "boolean", "required" => true }
            }
          }],
          "required" => true
        }
      }
    }
  end

  it "should provide repo data in the expected JSON format" do
    body = live_api_get_body('/api/v2/json/repos/show/chrisberkhout?page=1')
    JSON::Validator.validate!(@schema, body)
  end
  
  # NOTE: Additional testing here is less important than for the participation data,
  #       which unlinke repo data is not part of an official GitHub API.

end
