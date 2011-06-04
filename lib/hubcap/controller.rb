require 'hubcap/git_hub'

module Hubcap
  
  set :views,  File.join(File.expand_path(File.dirname(__FILE__)), "views")
  set :public, File.join(File.expand_path(File.dirname(__FILE__)), "public")
   
  respond = lambda do
    
    if !params[:login].nil? && !params[:login].empty?
      gh = GitHub.new(params.slice("login", "token").symbolize_keys)
      @data = gh.repos_with_participation
      if @data
        @repo_count = gh.repos.count
      else
        @error = true
      end
      # @data = [{"name" => "babushka-deps","size" => 1320,"created_at" => "2010/02/01 22 => 13 => 47 -0800","has_wiki" => false,"participation" => [0,0,0,0,0,2,0,3,0,0,0,0,0,5,11,10,3,0,0,0,0,0,0,0,15,22,0,0,7,30,4,0,0,0,0,0,0,0,14,0,0,9,3,5,0,0,0,0,0,2,1,0],"private" => false,"watchers" => 2,"language" => "Ruby","fork" => false,"url" => "https => //github.com/chrisberkhout/babushka-deps","pushed_at" => "2011/05/02 21 => 03 => 58 -0700","open_issues" => 0,"has_downloads" => true,"has_issues" => false,"homepage" => "","description" => "Babushka Deps","forks" => 2,"owner" => "chrisberkhout"},{"name" => "scaffapp","size" => 1368,"created_at" => "2010/06/25 00 => 30 => 54 -0700","has_wiki" => true,"participation" => [0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,0,0],"private" => false,"watchers" => 1,"language" => "Ruby","fork" => false,"url" => "https => //github.com/chrisberkhout/scaffapp","pushed_at" => "2011/04/23 08 => 28 => 22 -0700","open_issues" => 0,"has_downloads" => true,"has_issues" => true,"homepage" => "","description" => "","forks" => 1,"owner" => "chrisberkhout"},{"name" => "forbinoy","size" => 352,"created_at" => "2010/08/24 05 => 04 => 11 -0700","has_wiki" => true,"participation" => [0,0,0,0,0,0,0,0,0,0,0,0,0,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"private" => true,"watchers" => 1,"fork" => false,"url" => "https => //github.com/chrisberkhout/forbinoy","pushed_at" => "2010/12/13 18 => 35 => 56 -0800","open_issues" => 0,"has_downloads" => true,"has_issues" => true,"homepage" => "","description" => "For Binoy","forks" => 1,"owner" => "chrisberkhout"},{"name" => "dryft","size" => 992,"created_at" => "2010/08/12 07 => 21 => 56 -0700","has_wiki" => true,"participation" => [0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"private" => false,"watchers" => 2,"language" => "Ruby","fork" => false,"url" => "https => //github.com/chrisberkhout/dryft","pushed_at" => "2011/01/19 06 => 35 => 11 -0800","open_issues" => 0,"has_downloads" => true,"has_issues" => true,"homepage" => "","description" => "DRYFT for WinAutomation","forks" => 2,"owner" => "chrisberkhout"},{"name" => "beeswax","size" => 720,"created_at" => "2010/01/21 18 => 30 => 12 -0800","has_wiki" => true,"participation" => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"private" => true,"watchers" => 1,"fork" => false,"url" => "https => //github.com/chrisberkhout/beeswax","pushed_at" => "2010/08/27 09 => 06 => 42 -0700","open_issues" => 0,"has_downloads" => true,"has_issues" => true,"homepage" => "","description" => "Beeswax =>  Reporting for On The Job","forks" => 0,"owner" => "chrisberkhout"},{"name" => "taps-mssql-hack","size" => 364,"created_at" => "2010/09/12 05 => 43 => 16 -0700","has_wiki" => true,"participation" => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"private" => false,"watchers" => 4,"language" => "Ruby","fork" => true,"url" => "https => //github.com/chrisberkhout/taps-mssql-hack","pushed_at" => "2010/09/12 06 => 46 => 22 -0700","open_issues" => 0,"has_downloads" => true,"has_issues" => false,"homepage" => "","description" => "Fork of ricardochimal/taps, with a dodgy hack for pulling into MSSQL Server","forks" => 1,"owner" => "chrisberkhout"},{"name" => "cango","size" => 2032,"created_at" => "2010/10/19 21 => 19 => 47 -0700","has_wiki" => true,"participation" => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,16,6,0,6,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,7,0],"private" => false,"watchers" => 1,"language" => "Ruby","fork" => false,"url" => "https => //github.com/chrisberkhout/cango","pushed_at" => "2011/05/01 07 => 53 => 06 -0700","open_issues" => 0,"has_downloads" => true,"has_issues" => true,"homepage" => "","description" => "","forks" => 1,"owner" => "chrisberkhout"},{"name" => "ContentCleavage","size" => 484,"created_at" => "2010/11/14 05 => 03 => 16 -0800","has_wiki" => true,"participation" => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0],"private" => false,"watchers" => 1,"language" => "JavaScript","fork" => false,"url" => "https => //github.com/chrisberkhout/ContentCleavage","pushed_at" => "2011/03/11 00 => 05 => 07 -0800","open_issues" => 0,"has_downloads" => true,"has_issues" => true,"homepage" => "","description" => "See the split between comments and primary content","forks" => 1,"owner" => "chrisberkhout"},{"name" => "qwandry","size" => 140,"created_at" => "2010/12/11 07 => 37 => 48 -0800","has_wiki" => true,"participation" => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"private" => false,"watchers" => 1,"fork" => true,"url" => "https => //github.com/chrisberkhout/qwandry","pushed_at" => "2010/12/11 07 => 54 => 19 -0800","open_issues" => 0,"has_downloads" => true,"has_issues" => false,"homepage" => "http => //endofline.wordpress.com/2010/12/07/qwandry-is-the-new-open-gem/","description" => "Qwandry gives you a single way to easily open all your projects and libraries.","forks" => 0,"owner" => "chrisberkhout"},{"name" => "lpbatch","size" => 228,"created_at" => "2011/01/04 02 => 21 => 37 -0800","has_wiki" => true,"participation" => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"private" => true,"watchers" => 2,"fork" => false,"url" => "https => //github.com/chrisberkhout/lpbatch","pushed_at" => "2011/01/04 02 => 22 => 44 -0800","open_issues" => 0,"has_downloads" => true,"has_issues" => true,"homepage" => "","description" => "Lonely Planet recruitment coding task","forks" => 0,"owner" => "chrisberkhout"},{"name" => "babushka","size" => 336,"created_at" => "2011/01/15 23 => 25 => 11 -0800","has_wiki" => true,"participation" => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"private" => false,"watchers" => 1,"language" => "Ruby","fork" => true,"url" => "https => //github.com/chrisberkhout/babushka","pushed_at" => "2011/01/17 21 => 34 => 13 -0800","open_issues" => 0,"has_downloads" => true,"integrate_branch" => "master","has_issues" => false,"homepage" => "http => //babushka.me","description" => "Test-driven sysadmin.","forks" => 0,"owner" => "chrisberkhout"},{"name" => "rag_deploy","size" => 1040,"created_at" => "2011/04/18 06 => 46 => 50 -0700","has_wiki" => true,"participation" => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,16,2,4],"private" => false,"watchers" => 3,"language" => "Ruby","fork" => false,"url" => "https => //github.com/chrisberkhout/rag_deploy","pushed_at" => "2011/05/03 02 => 40 => 58 -0700","open_issues" => 0,"has_downloads" => true,"has_issues" => true,"homepage" => "","description" => "RAG Deploy","forks" => 1,"owner" => "chrisberkhout"},{"name" => "arel","size" => 5168,"created_at" => "2011/04/27 03 => 42 => 39 -0700","has_wiki" => true,"participation" => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0],"private" => false,"watchers" => 1,"language" => "Ruby","fork" => true,"url" => "https => //github.com/chrisberkhout/arel","pushed_at" => "2011/04/27 03 => 50 => 51 -0700","open_issues" => 0,"has_downloads" => true,"has_issues" => false,"homepage" => "","description" => "A Relational Algebra","forks" => 0,"owner" => "chrisberkhout"},{"name" => "hubcap","size" => 1348,"created_at" => "2011/05/13 22 => 48 => 22 -0700","has_wiki" => true,"participation" => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,23],"private" => false,"watchers" => 1,"language" => "JavaScript","fork" => false,"url" => "https => //github.com/chrisberkhout/hubcap","pushed_at" => "2011/05/21 08 => 02 => 54 -0700","open_issues" => 0,"has_downloads" => true,"has_issues" => true,"homepage" => "","description" => "A visual recap of your GitHub activity","forks" => 1,"owner" => "chrisberkhout"},{"name" => "newsroo","size" => 3316,"created_at" => "2011/05/10 07 => 13 => 28 -0700","has_wiki" => true,"participation" => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4],"private" => true,"watchers" => 1,"language" => "PHP","fork" => false,"url" => "https => //github.com/chrisberkhout/newsroo","pushed_at" => "2011/05/10 08 => 12 => 11 -0700","open_issues" => 0,"has_downloads" => true,"has_issues" => true,"homepage" => "","description" => "","forks" => 0,"owner" => "chrisberkhout"},{"name" => "chrisberkhout_com","size" => 436,"created_at" => "2011/05/10 06 => 42 => 11 -0700","has_wiki" => true,"participation" => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12],"private" => true,"watchers" => 1,"fork" => false,"url" => "https => //github.com/chrisberkhout/chrisberkhout_com","pushed_at" => "2011/05/10 06 => 50 => 05 -0700","open_issues" => 0,"has_downloads" => true,"has_issues" => true,"homepage" => "","description" => "","forks" => 0,"owner" => "chrisberkhout"}].map!{ |r| Repo.new(r) }
    end
    
    if @data.nil?
      haml :index
    else
      haml :report
    end

  end

  get  '/', &respond
  post '/', &respond

end
