
def fakeweb_chrisberkhout
  data = {
    :login => "chrisberkhout",
    :token => "ef57c2ff4b4a75a2727e90927ebf52eb",
    :repo_names => ["hubcap", "rag_deploy", "beeswax"]
  }
  
  FakeWeb.allow_net_connect = false
  
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

def fakeweb_drnic
  
end
