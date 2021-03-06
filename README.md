# Hubcap

A visual recap of your GitHub commits.

## Screenshot

![screenshot](doc/screenshot.gif)

## Status

**Hubcap has stopped working because GitHub has stopped running their v2 API.**

Hubcap was a fun experiment and coding exercise. It was working, but had 
several limitations. No further development is planned.

## Introduction

After reading about ["Jerry Seinfeld's Productivity Secret"](http://lifehacker.com/281626/jerry-seinfelds-productivity-secret)
I started taking more notice of the 52 week participation graphs on my GitHub
repos. I knew my non-work coding activity had been cyclical and I thought that
a visualisation covering all my repos might help me become more consistent.

## Run it locally

    # get the code
    git clone git://github.com/chrisberkhout/hubcap.git && cd hubcap
    bundle install
    
    # run specs and check GitHub APIs are alive
    bundle exec rspec spec/hubcap
    bundle exec rspec spec/live_api
    
    # start the server
    bundle exec rackup -p 4567 config.ru

## Limitations

Data is pulled from GitHub upon request and nothing is stored. That means there 
is one connection to GitHub for each page of repo info (100 repos per page), 
and one for each repo's participation data. Obviously, that is slow. It can
take up to a couple of minutes. Using a HTTP keep-alive connection would
probably improve it greatly. Another potential improvement would be to return
a page that informs the user that loading is in progress, then to push out the
results when they are ready.

I have limited fetching of participation data to the 20 most recently pushed
repositories. GitHub often limits it to a smaller number. It appears that the
participation data is generated on request and cached. Successive requests
seem to deliver more and more data, presumably all the cached figures and some
newly calculated ones each time. 

The 52 week participation data used for GitHub's charts is not part of an 
official GitHub API, so it may disappear altogether in the future.

Due to the limit on the number of repos we can get participation data for,
some of the 52 weeks may show only partial data. Any period of partial data
coverage will be indicated on the chart.

In case you choose to use your GitHub API token, be aware that it will be sent
in plain text. You can always reset your API token by changing your GitHub
password.

Due to the GitHub limitations, a better approach to this application would be to
visualise data from local repositories instead of from GitHub.

## Compatibility

Written and tested with Ruby 1.9.2p290.

## Feedback

I'd be happy to hear your thoughts about Hubcap!
The best way to reach me is via email at gmail.com (chrisberkhout@).

## Copyright

The MIT License

Copyright (C) 2011 by Chris Berkhout (http://chrisberkhout.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
