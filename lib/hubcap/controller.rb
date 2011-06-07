require 'hubcap/repo_collection'

module Hubcap
  
  set :views,  File.join(File.expand_path(File.dirname(__FILE__)), "views")
  set :public, File.join(File.expand_path(File.dirname(__FILE__)), "public")
   
  respond = lambda do
    
    if !params[:login].nil? && !params[:login].empty?
      begin
        @repos = RepoCollection.new(params.slice("login", "token").symbolize_keys)
      rescue
        @error = true
      end
    end
    
    if @repos.nil?
      haml :index
    else
      haml :report
    end

  end

  get  '/', &respond
  post '/', &respond

end
