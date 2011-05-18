require 'net/http'
require 'httparty'
require 'json'

module Hubcap
  class GitHub
    include HTTParty
    base_uri "https://github.com"
    
    def initialize(options={})
      login = options[:login] || raise("No login provided!")
      @auth_params = { 'login' => login }
      @auth_params['token'] = options[:token] if options[:token]
    end
    
    def repos(options={})
      options.merge!({:body => @auth_params})
      
      repos = []
      next_url = "/api/v2/json/repos/show/#{@auth_params['login']}?page=1"
      while next_url
        response = self.class.post(next_url, options)
        repos += JSON.parse(response.body)["repositories"]
        next_url = response.headers['x-next']
      end

      repos.each_with_index do |repo, index|
        response = self.class.post("/#{@auth_params['login']}/#{repo['name']}/graphs/participation", options)
        owner_commits = response.body.split(/[\r\n]+/)[1]
        owner_commits.length == (52 * 2) || raise("Bad participation data for #{repo['name']}.")
        repos[index]["participation"] = owner_commits.scan(/../).map{ |code| base64_to_int(code) }
      end

      repos.reduce({}) { |hash, repo| hash[repo["name"]] = repo; hash }
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
