require 'fakeweb'

def fakeweb_init
  FakeWeb.clean_registry
  FakeWeb.allow_net_connect = false
end

def fakeweb_disable
  FakeWeb.clean_registry
  FakeWeb.allow_net_connect = true
end

def fakeweb_chrisberkhout
  fakeweb_init

  data = {
    :login => "chrisberkhout",
    :token => "ef57c2ff4b4a75a2727e90927ebf52eb",
    :repo_names => ["hubcap", "rag_deploy", "beeswax"],
    :last_pushed_desc => ["hubcap", "rag_deploy", "beeswax"],
    :first_commit_then_last_commit => ["beeswax", "hubcap", "rag_deploy"]
  }
  
  FakeWeb.register_uri(
    :any, "https://github.com/api/v2/json/repos/show/#{data[:login]}?page=1", 
    :body => File.read("spec/resources/repos_show_#{data[:login]}_1.json")
  )

  data[:repo_names].each do |repo_name|
    FakeWeb.register_uri(
      :any, "https://github.com/#{data[:login]}/#{repo_name}/graphs/participation", 
      :body => File.read("spec/resources/participation_#{data[:login]}_#{repo_name}.base64")
    )
  end
  
  data
end

def fakeweb_chrisberkhout_badcredentials
  fakeweb_init

  data = {
    :login => "chrisberkhout",
    :loginwrong => "chrisberkhoutwrong",
    :badtoken => "wrong"
  }
  
  FakeWeb.register_uri(
    :any, "https://github.com/api/v2/json/repos/show/#{data[:loginwrong]}?page=1", 
    :body => File.read("spec/resources/repos_show_#{data[:loginwrong]}_1.json")
  )

  FakeWeb.register_uri(
    :any, "https://github.com/api/v2/json/repos/show/#{data[:login]+"badtoken"}?page=1", 
    :body => File.read("spec/resources/repos_show_#{data[:login]}_1-badtoken.json")
  )
  
  data
end

def fakeweb_drnic(options = {:limit_to => 20})
  fakeweb_init
  
  FakeWeb.register_uri(
    :any, "https://github.com/api/v2/json/repos/show/drnic?page=1", 
    :body => File.read("spec/resources/repos_show_drnic_1.json"),
    :x_next => "https://github.com/api/v2/json/repos/show/drnic?page=2"
  )
  
  FakeWeb.register_uri(
    :any, "https://github.com/api/v2/json/repos/show/drnic?page=2", 
    :body => File.read("spec/resources/repos_show_drnic_2.json")
  )
  
  FakeWeb.register_uri(
    :any, %r|https\://github\.com/drnic/.*?/graphs/participation|, 
    [{:body => File.read("spec/resources/participation_drnic_all.base64"), :times => options[:limit_to]},
     {:body => File.read("spec/resources/participation_drnic_limited.base64")}]
  )
  
  data = {
    :repo_count => 168,
    :most_recently_pushed => ["FakeWeb.tmbundle", "em-synchrony", "sinatra-synchrony", "sinatra-synchrony-example", "rails_wizard.web", ".dotfiles", "redcar", "red-dirt-workers-tutorial", "svruby-awards", "queue_classic", "test_edge_rails", "magic_multi_connections", "ci_demo_app", "rubigen", "tabtab", "todolist-webinar", "todolist-app", "composite_primary_keys", "docrails", "grape_test_app"]
  }
end
