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
      @auth_params['token'] = options[:token] if options[:token] && !options[:token].empty?
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
      repos
    end
    
    def repos_with_participation(options={})
      all_repos = self.repos(options)
      all_repos.sort!{|x,y| y['pushed_at'] <=> x['pushed_at'] }
      options.merge!({:body => @auth_params})
      repos_with_participation = []
      all_repos[0..19].each do |repo|
        response = self.class.post("/#{@auth_params['login']}/#{repo['name']}/graphs/participation", options)
        owner_commits = response.body.split(/[\r\n]+/)[1]
        owner_commits.length == (52 * 2) || raise("Bad participation data for #{repo['name']}.")
        repo["participation"] = owner_commits.scan(/../).map{ |code| base64_to_int(code) }
        repos_with_participation.push(repo)
      end
      repos_with_participation = repos_with_participation.
          select{ |r| r["participation"].inject(0){ |acc,i| acc+i } > 0 }.
          sort_by{ |r| [first_commit_week(r), last_commit_week(r)] }
    end
    
    protected

    def first_commit_week(repo)
      repo["participation"].index{ |x| x != 0 }
    end

    def last_commit_week(repo)
      (repo["participation"].length-1) - repo["participation"].reverse.index{ |x| x != 0 }
    end

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
