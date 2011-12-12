require 'net/http'
require 'httparty'
require 'json'

require 'hubcap/repo'

module Hubcap
  
  # Scrapes repository and participation data from GitHub.
  #
  # Parsing of participation data is done here because it is part of
  # the scraping, but other logic related to repos (e.g. extracting
  # data to sort on) is encapsulated in {Repo}.
  #
  class GithubAPI
    include HTTParty
    base_uri "https://github.com"
    
    def initialize(options={})
      login = options[:login] || raise("No login provided!")
      @auth_params = { 'login' => login }
      @auth_params['token'] = options[:token] if options[:token] && !options[:token].empty?
    end
    
    def repos
      repos = []
      next_url = "/api/v2/json/repos/show/#{@auth_params['login']}?page=1"
      while next_url
        response = self.class.post(next_url, {:body => @auth_params})
        data = JSON.parse(response.body)
        raise ("Unexpected JSON repo data (#{data.inspect}).") unless data["repositories"]
        repos += data["repositories"]
        next_url = response.headers['x-next']
      end
      repos
    end
    
    def participation(repo_name)
      response = self.class.post("/#{@auth_params['login']}/#{repo_name}/graphs/participation", {:body => @auth_params})
      owner_commits = JSON.parse(response.body)["owner"]
    end
    
  end
end
