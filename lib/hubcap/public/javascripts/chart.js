
var w = 1040+20,
    h = 250+20,
    x = pv.Scale.ordinal(pv.range(52)).splitBanded(0, w, 4/5),
    y = pv.Scale.linear(0, 50).range(0, h);
 
var vis = new pv.Panel()
    .width(w)
    .height(h)
    .bottom(10)
    .left(10)
    .right(10)
    .top(10);
 
var bar = vis.add(pv.Layout.Stack)
    .layers(data)
    .x(function() { return x(this.index); })
    .y(y)
  .layer.add(pv.Bar)
    .width(x.range().band);


// example fixed for v3.2: http://vadim.ogievetsky.com/projects/mark/bar-stacked.html

// seems to be a difference between using x() and y() of stack/layers thingo, vs manual bottom().

// read: http://eagereyes.org/tutorials/protovis-primer-part-2
// read: http://eagereyes.org/tutorials/protovis-primer-part-3
// read: http://vis.stanford.edu/protovis/jsdoc/symbols/pv.Layout.Stack.html
// read: something about pv.Scale.ordinal(pv.range(52)).splitBanded(0, w, 4/5)

vis.render();
