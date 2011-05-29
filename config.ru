Dir.chdir("lib") do
  require "hubcap"
  run Sinatra::Application
end
