require 'net/http'
require 'httparty'
require 'json'

require 'hubcap/repo'

module Hubcap
  
  # Scrapes repository and participation data from GitHub.
  #
  # Decoding of base64 participation data is done here because it is 
  # part of the scraping, but other logic related to repos (e.g. extracting
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
        repos += JSON.parse(response.body)["repositories"]
        next_url = response.headers['x-next']
      end
      repos
    end
    
    def participation(repo_name)
      response = self.class.post("/#{@auth_params['login']}/#{repo_name}/graphs/participation", {:body => @auth_params})
      owner_commits = response.body.split(/[\r\n]+/)[1]
      owner_commits.length == (52 * 2) || raise("Bad participation data for #{repo_name}.")
      owner_commits.scan(/../).map{ |code| base64_to_int(code) }
    end
    
    private

    # Decodes from "modified Base64 for regexps" to an array of integers.
    # It was clear from GitHub's JavaScript that they are using this encoding.
    # See: {http://en.wikipedia.org/wiki/Base64#Regular_expressions}
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
