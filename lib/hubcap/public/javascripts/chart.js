/* Sizing and scales. */

var w = 1040,
    h = 300;
    x = pv.Scale.linear(0, 51).range(0, 51),
    y = pv.Scale.linear(0, 20).range(0, h); // should set 20 to be the max(7,max(data))

var vis = new pv.Panel()
    .width(w)
    .height(h)
    .bottom(20)
    .left(20)
    .right(10)
    .top(5);

vis.add(pv.Panel)
    .data(data)
  .add(pv.Bar)
    .data(function(a) { return a; })
    .width(16)
    .height(y)
    .bottom(0) // pv.Layout.stack()
    .left(function() { return this.index * 20; });


// NOT SURE HOW TO STACK! SEE: http://vis.stanford.edu/protovis/jsdoc/symbols/pv.Layout.Stack.html

vis.render();

// var data = pv.range(10).map(function(d) { return (Math.random() + .1); });
// 
// /* Sizing and scales. */
// var w = 400,
//     h = 250,
//     x = pv.Scale.linear(0, 1.1).range(0, w),
//     y = pv.Scale.ordinal(pv.range(10)).splitBanded(0, h, 4/5);
// 
// /* The root panel. */
// var vis = new pv.Panel()
//     .width(w)
//     .height(h)
//     .bottom(20)
//     .left(20)
//     .right(10)
//     .top(5);
// 
// /* The bars. */
// var bar = vis.add(pv.Bar)
//     .data(data)
//     .top(function() { return y(this.index); })
//     .height(y.range().band)
//     .left(0)
//     .width(x);
// 
// /* The value label. */
// bar.anchor("right").add(pv.Label)
//     .textStyle("white")
//     .text(function(d) { return d.toFixed(1); });
// 
// /* The variable label. */
// bar.anchor("left").add(pv.Label)
//     .textMargin(5)
//     .textAlign("right")
//     .text(function() { return "ABCDEFGHIJK".charAt(this.index); });
// 
// /* X-axis ticks. */
// vis.add(pv.Rule)
//     .data(x.ticks(5))
//     .left(x)
//     .strokeStyle(function(d) { return (d ? "rgba(255,255,255,.3)" : "#000"); })
//   .add(pv.Rule)
//     .bottom(0)
//     .height(5)
//     .strokeStyle("#000")
//   .anchor("bottom").add(pv.Label)
//     .text(x.tickFormat);
// 
// vis.render();
