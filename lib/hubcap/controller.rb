module Hubcap

  set :views,  Proc.new { File.join(root, "hubcap/views") }
  set :public, Proc.new { File.join(root, "hubcap/public") }
   
  respond = lambda do
    
    # if request.env['REQUEST_METHOD'] == 'POST'; end
    if params[:login].nil? || params[:login].empty?
    
      if params.length > 0
        # warn that login needs to be filled out
      end
      haml :index
    
    else

      @repos = HubStats.new(params.slice("login", "token").symbolize_keys).repos
      haml :report

    end
  
  end

  get  '/', &respond
  post '/', &respond

end
