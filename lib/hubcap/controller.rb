set :views, Proc.new { File.join(root, "hubcap/views") }

get '/' do
  
  if params[:login].nil? || params[:login].empty?

    if params.length == 0
      haml :index
    else
      redirect to('/')
    end
    
  else
    
    haml :report
    
  end
  
end
