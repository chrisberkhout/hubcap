require 'net/http'
require 'uri'

module Hubcap
  
  class HubStats
    
    def initialize(opts)
      
      @username = opts[:username] || raise("No username provided!")
      @auth_params = { 'login' => @username }
      @auth_params['token'] = opts[:token] if opts[:token]

      repo_list_url = URI.parse("http://github.com/api/v2/json/repos/show/#{@username}")
      result = Net::HTTP.post_form(repo_list_url, @auth_params)
      
      
      
      # process JSON to build @repos object
      
      # repo_participation_url = URI.parse("https://github.com/#{@username}/#{repo}/graphs/participation")
      # result = Net::HTTP.post_form(repo_participation_url, @auth_params)
      # result.body
      # # process JSON to build on @repos object

      @repos
    end
    
    def repos
      @repos
    end
    
  end
  
end
