set :views, Proc.new { File.join(root, "hubcap/views") }

respond = lambda do

  # if request.env['REQUEST_METHOD'] == 'POST'; end

  if params[:login].nil? || params[:login].empty?
    
    if params.length > 0
      # warn that login needs to be filled out
    end
    haml :index
    
  else

    haml :report

  end
end

get  '/', &respond
post '/', &respond
