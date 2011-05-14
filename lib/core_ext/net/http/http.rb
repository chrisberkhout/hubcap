module Net
  class HTTP < Protocol
    # The original HTTP.post_form method is defined in Ruby's "lib/net/http.rb"
    # This one allows posting to a URL with a query string (e.g. http://host.com/script?q=something)
    def HTTP.post_form_with_query(url, params)
      req = Post.new(url.request_uri)
      req.form_data = params
      req.basic_auth url.user, url.password if url.user
      new(url.host, url.port).start {|http|
        http.request(req)
      }
    end
  end
end
