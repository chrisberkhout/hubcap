require 'net/http'
require 'uri'
require 'json'

module Hubcap
  
  class HubStats
    
    attr_accessor :repos
    
    def initialize(opts)
      
      @username = opts[:username] || raise("No username provided!")
      @auth_params = { 'login' => @username }
      @auth_params['token'] = opts[:token] if opts[:token]

      repo_list_url = URI.parse("http://github.com/api/v2/json/repos/show/#{@username}")
      result = Net::HTTP.post_form(repo_list_url, @auth_params)
      
      repo_array = JSON.parse(result.body)["repositories"]
      @repos = repo_array.reduce({}) { |hash, repo| hash[repo["name"]] = repo; hash }

      
      # repo_participation_url = URI.parse("https://github.com/#{@username}/#{repo}/graphs/participation")
      # result = Net::HTTP.post_form(repo_participation_url, @auth_params)
      # result.body
      # # process JSON to build on @repos object

    end
    
  end
  
end
