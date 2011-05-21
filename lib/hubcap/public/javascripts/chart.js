var totals_by_week = [];
(function() {
    var repo_index = 0;
    data.forEach(function(repo) { 
        var week_index = 0;
        repo.forEach(function(commit_count) { 
            totals_by_week[week_index] = (totals_by_week[week_index] || 0) + commit_count;
            week_index += 1;
        });
    });
})();
var max_commits = Math.max.apply(Math, totals_by_week);
                    
var w = 1040,
    h = 250,
    x = pv.Scale.ordinal(pv.range(52)).splitBanded(0, w, 4/5),
    y = pv.Scale.linear(0, Math.max(max_commits,7)).range(0, h);
 
var vis = new pv.Panel()
    .width(w+20)
    .height(h+20)
    .bottom(10)
    .left(10)
    .right(10)
    .top(10);
 
var bars = vis.add(pv.Layout.Stack)
    .layers(data)
        .x(function() { return x(this.index); })
        .y(y)
    .layer.add(pv.Bar)
        .width(x.range().band);
    
var labels = vis.add(pv.Label)
    .data(totals_by_week)
        .left(function() { return x(this.index) + x.range().band / 2; })
        .bottom(y)
        .textAlign("center")
        .text(function(d) { return d; })
        .visible(function(d) { return d > 0; });


// example fixed for v3.2: http://vadim.ogievetsky.com/projects/mark/bar-stacked.html

// seems to be a difference between using x() and y() of stack/layers thingo, vs manual bottom().

// read: http://eagereyes.org/tutorials/protovis-primer-part-2
// read: http://eagereyes.org/tutorials/protovis-primer-part-3
// read: http://vis.stanford.edu/protovis/jsdoc/symbols/pv.Layout.Stack.html
// read: something about pv.Scale.ordinal(pv.range(52)).splitBanded(0, w, 4/5)

// colours: http://vis.stanford.edu/protovis/docs/color.html

vis.render();
