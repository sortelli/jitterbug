window.progress_chart = (svg_id, bugs) ->
  bug_stats = bugs.names.map((name) -> bugs.stats[name])
  colors    = bugs.color_scale.map((color) -> color.rgb)

  if bugs.plots?
    bug_stats.map (stat, i) ->
      bugs.plots[i].addDataset("stats", stat)
  else
    bugs.plots = render_plots(svg_id, bug_stats, colors, bugs.max_turns, bugs.count)

render_plots = (svg_id, bug_stats, colors, max_turns, max_bugs) ->
  $(svg_id).empty()

  xScale     = new Plottable.Scale.Linear().domain([0, max_turns])
  yScale     = new Plottable.Scale.Linear().domain([0, max_bugs])
  colorScale = new Plottable.Scale.Color().range(colors)

  xAxis  = new Plottable.Axis.Numeric(xScale, "bottom")
  yAxis  = new Plottable.Axis.Numeric(yScale, "left")
  yLabel = new Plottable.Component.Label("Num of Jitterbugs", "left")
  xLabel = new Plottable.Component.Label("Turn")
  legend = new Plottable.Component.Legend(colorScale)

  plots = bug_stats.map (stat) ->
    last_stat = stat[stat.length - 1]
    return new Plottable.Plot.Line(xScale, yScale)
                      .animate(false)
                      .addDataset("stats", stat)
                      .project("x", "iteration", xScale)
                      .project("y", "count", yScale)
                      .project("stroke", colorScale.scale(last_stat.name))
                      .project("stroke-width", 1)

  gridlines = new Plottable.Component.Gridlines(xScale, yScale)
  center    = new Plottable.Component.Group(plots).above(gridlines)
  table     = new Plottable.Component.Table([
    [null,   null,  legend],
    [yLabel, yAxis, center],
    [null,   null,  xAxis ],
    [null,   null,  xLabel]
  ]).renderTo(svg_id)

  plots
