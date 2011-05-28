require 'httparty'

module LiveApiHelper
  class GitHubLiveAPI
    include HTTParty
    base_uri "https://github.com"
  end
end

def live_api_get_body(path)
  LiveApiHelper::GitHubLiveAPI.get(path).body
end
