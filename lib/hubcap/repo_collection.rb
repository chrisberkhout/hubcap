require 'hubcap/github_api'

module Hubcap
  class RepoCollection
    
    def initialize(param)
      if param.class == Hash
        @github = GithubAPI.new(param)
        @repos = @github.repos.map{ |r| Repo.new(r) }
        self.get_some_participation
        # set colors
      elsif param.class == Array
        @github, @repos = param
      else
        raise ArgumentError, "It was this one!"
      end
    end
    
    # def to_json
    #   @repos.to_json
    # end
    
    def method_missing(method, *args, &block)
      result = @repos.send(method, *args, &block)
      if result.class == Array
        RepoCollection.new([@github, result])
      else
        result
      end
    end
      
    def by_last_pushed_desc
      self.sort{ |x,y| y.pushed_or_created_at <=> x.pushed_or_created_at }
    end

    def by_first_commit_then_last_commit
      self.sort_by{ |r| [r.first_commit_week, r.last_commit_week] }
    end

    def with_participation
      self.select{ |r| !r['participation'].nil? }
    end

    def without_participation
      self.select{ |r| r['participation'].nil? }
    end
    
    # stats & date aggregates:
      # weeks covered with participation
      # date of last push or create for least recently pushed/created repo with participation

    protected
    
    def get_some_participation
      # attempt fetching up to 20 repos, until one fails
      self.without_participation.by_last_pushed_desc[0..19].each do |repo|
        begin
          repo["participation"] = @github.participation(repo['name'])
        rescue
          break
        end
      end
    end

  end
end
