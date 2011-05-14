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

      repo_list_url = URI.parse("https://github.com/api/v2/json/repos/show/#{@username}")
      result = Net::HTTP.post_form(repo_list_url, @auth_params)
      
      repo_array = JSON.parse(result.body)["repositories"]
      @repos = repo_array.reduce({}) { |hash, repo| hash[repo["name"]] = repo; hash }

      @repos.each_pair do |repo_name, data|
        participation_url = URI.parse("https://github.com/#{@username}/#{repo_name}/graphs/participation")
        owner_commits = Net::HTTP.post_form(participation_url, @auth_params).body.split(/[\r\n]+/)[1]
        owner_commits.length == (52 * 2) || raise("Bad participation data for #{repo_name}.")
        @repos[repo_name]["participation"] = owner_commits.scan(/../).map{ |code| base64_to_int(code) }
      end

    end
    
    protected
    
    def base64_to_int(input)
      table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!-"
      result = 0
      input.scan(/./).reverse.each_with_index do |digit, index|
        multiplier = (index == 0) ? 1 : index * 64
        result = result + (table.index(digit) * multiplier)
      end
      result
    end

  end
end
