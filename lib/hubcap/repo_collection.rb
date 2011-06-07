require 'hubcap/github_api'

module Hubcap
  class RepoCollection < Array
    
    def initialize(*args, &block)
      if args[0].class == Hash
        github = GithubAPI.new(args[0])
        super(github.repos.map{ |r| Repo.new(r) }, &block)
        get_some_participation(github)
        set_colors
      else
        super(*args, &block)
      end
    end
      
    def by_last_pushed_desc
      sort{ |x,y| y.pushed_or_created_at <=> x.pushed_or_created_at }
    end

    def by_first_commit_then_last_commit
      sort_by{ |r| [r.first_commit_week, r.last_commit_week] }
    end

    def with_participation
      reject{ |r| r["participation"].nil? }
    end

    def without_participation
      reject{ |r| !r["participation"].nil? } # select would return an Array instead of RepoCollection!
    end
    
    # stats & date aggregates:
      # weeks covered with participation
      # date of last push or create for least recently pushed/created repo with participation

    private
    
    def get_some_participation(github)
      # attempt fetching up to 20 repos, until one fails
      without_participation.by_last_pushed_desc[0..19].each do |repo|
        begin
          repo["participation"] = github.participation(repo['name'])
        rescue
          break
        end
      end
    end
    
    def set_colors
      protovis_category10 = ["#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf"]
      protovis_category20 = ["#1f77b4", "#aec7e8", "#ff7f0e", "#ffbb78", "#2ca02c", "#98df8a", "#d62728", "#ff9896", "#9467bd", "#c5b0d5", "#8c564b", "#c49c94", "#e377c2", "#f7b6d2", "#7f7f7f", "#c7c7c7", "#bcbd22", "#dbdb8d", "#17becf", "#9edae5"]
      chosen_colors = with_participation.count <= 10 ? protovis_category10 : protovis_category20
      with_participation.by_first_commit_then_last_commit.each do |r|
        r.merge!({ "color" => chosen_colors.shift })
      end
    end

  end
end
