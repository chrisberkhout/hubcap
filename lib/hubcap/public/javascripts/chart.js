var participation = data.reduce(function(acc,repo) { acc.push(repo["participation"]); return acc; }, [])

var totals_by_week = [];
(function() {
    var repo_index = 0;
    participation.forEach(function(repo) { 
        var week_index = 0;
        repo.forEach(function(commit_count) { 
            totals_by_week[week_index] = (totals_by_week[week_index] || 0) + commit_count;
            week_index += 1;
        });
    });
})();
var max_commits = Math.max.apply(Math, totals_by_week);
var max_range = Math.max(max_commits,7);
                    
var w = 1040,
    h = 250,
    x = pv.Scale.ordinal(pv.range(52)).splitBanded(0, w, 4/5),
    y = pv.Scale.linear(0, max_range).range(0, h);
 
var vis = new pv.Panel()
    .width(w)
    .height(h)
    .bottom(20)
    .left(20)
    .right(20)
    .top(20);
 
var rule_ticks = 6;
var rule_step = Math.ceil(max_range/(rule_ticks-1));
var rule_top = rule_step * rule_ticks;
var rules = vis.add(pv.Rule)
    .data(pv.range(0, rule_top, rule_step))
    .bottom(y)
    .strokeStyle("lightgray")
    .anchor("left").add(pv.Label)
        .textStyle("lightgray");

var bars = vis.add(pv.Layout.Stack)
    .layers(participation)
        .x(function() { return x(this.index); })
        .y(y)
    .layer.add(pv.Bar)
        .width(x.range().band);

var domain_labels = vis.add(pv.Label)
    .data(totals_by_week)
        .left(function() { return x(this.index) + x.range().band / 2; })
        .bottom(-18)
        .textAlign("center")
        .textStyle("lightgray")
        .text(function() { return - (this.index - this.scene.length); });

var range_labels = vis.add(pv.Label)
    .data(totals_by_week)
        .left(function() { return x(this.index) + x.range().band / 2; })
        .bottom(y)
        .textAlign("center")
        .visible(function(d) { return d > 0; });

vis.render();
