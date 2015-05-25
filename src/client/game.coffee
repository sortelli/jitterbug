make_chart = (svg_id, bug_stats) ->
  $(svg_id).empty()

  xScale     = new Plottable.Scale.Linear()
  yScale     = new Plottable.Scale.Linear()
  colorScale = new Plottable.Scale.Color("10")

  xAxis  = new Plottable.Axis.Numeric(xScale, "bottom")
  yAxis  = new Plottable.Axis.Numeric(yScale, "left")
  yLabel = new Plottable.Component.Label("Num of Jitterbugs", "left")
  legend = new Plottable.Component.Legend(colorScale)

  plots = bug_stats.map (stat) ->
    return new Plottable.Plot.Line(xScale, yScale)
                      .addDataset(stat)
                      .project("x", "iteration", xScale)
                      .project("y", "count", yScale)
                      .project("stroke", colorScale.scale(stat[0].name))
                      .project("stroke-width", 1)

  gridlines = new Plottable.Component.Gridlines(xScale, yScale)
  center    = new Plottable.Component.Group(plots).above(gridlines).below(legend)
  table     = new Plottable.Component.Table([
    [yLabel, yAxis, center],
    [null,   null,  xAxis ]
  ]).renderTo(svg_id)

jitterbug_game = (canvas_id) ->
  canvas = new fabric.Canvas 'jitterbug_game_canvas',
    backgroundColor:   "#CCCCCC"
    renderOnAddRemove: false

  fabric.Object.prototype.transparentCorners = false

  canvas.setHeight  400
  canvas.setWidth  600

  bugs  = starting_bugs()
  render_game canvas, bugs

  next_turn bugs, canvas

next_turn = (bugs, canvas) ->
  next_iteration bugs
  render_game canvas, bugs

  if bugs.turns % 10 == 0
    stats = bugs.names.map((name) -> bugs.stats[name])
    make_chart '#jitterbug_progress_chart_svg', stats

  if bugs.turns < 1000
    bugs.turns += 1
    setTimeout((-> next_turn bugs, canvas), 50)

empty_grid = ->
  grid = []

  for x in [0..59]
    grid[x] = []
    for y in [0..39]
      grid[x][y] = null

  grid

starting_bugs = ->
  bugs =
    grid:        empty_grid()
    colors:      {}
    next_serial: 0
    stats:       {}
    names:       []
    next_color:  ['black', 'yellow', 'blue', 'grey', 'pink', 'green', 'red']
    turns:       0

  for i in [0..10]
    add_bug bugs, 'fly_trap', create_fly_trap

  for i in [0..10]
    add_bug bugs, 'moth1', create_moth

  for i in [0..10]
    add_bug bugs, 'moth2', create_moth

  bugs

add_bug = (bugs, name, move) ->
  location  = random_location bugs
  direction = random_num 3
  color     = bugs.colors[name]

  unless color?
    color = bugs.next_color.pop()
    throw new Error("This game does not support this many bug types") unless color?
    bugs.colors[name] = color

  bugs.grid[location.x][location.y] =
    move:      move
    name:      name
    direction: direction
    location:  location
    color:     color
    serial:    (bugs.next_serial += 1)

  unless bugs.stats[name]?
    bugs.stats[name] = [{iteration: 0, count: 0, name: name}]
    bugs.names.push name

  bugs.stats[name][0].count += 1

random_location = (bugs) ->
  x = random_num 59
  y = random_num 39

  if (bugs.grid[x][y]?)
    random_location bugs
  else
    x: x, y: y

next_iteration = (bugs) ->
  bug_list = []

  for column in bugs.grid
    for bug in column
      if bug?
        bug_list.push bug

  shuffle_array bug_list

  for bug in bug_list
    move_bug bugs, bug

  bugs.names.map (name) ->
    count = bug_list.reduce(
      ((sum, bug) -> if bug.name == name then sum + 1 else sum), 0)
    bugs.stats[name].push
      iteration: bugs.turns
      count:     count
      name:      name

info_at_location = (grid, bug, x, y) ->
  info = if x < 0 or y < 0 or x == 59 or y == 39
    'WALL'
  else if !grid[x][y]?
    'EMPTY'
  else if grid[x][y].name == bug.name
    'SAME'
  else
    'OTHER'

  info: info, x: x, y: y

direction_name = (direction) ->
  switch direction
    when 0 then 'NORTH'
    when 1 then 'EAST'
    when 2 then 'SOUTH'
    else        'WEST'

move_bug = (bugs, bug) ->
  x = bug.location.x
  y = bug.location.y
  d = bug.direction

  surrounding_info = [
    info_at_location bugs.grid, bug, x, y - 1   # North
    info_at_location bugs.grid, bug, x + 1, y   # East
    info_at_location bugs.grid, bug, x, y + 1   # South
    info_at_location bugs.grid, bug, x - 1, y   # West
  ]

  while d-- > 0
    surrounding_info.push(surrounding_info.shift())

  info =
    front:     surrounding_info[0].info
    left:      surrounding_info[1].info
    right:     surrounding_info[2].info
    back:      surrounding_info[3].info
    direction: bug.direciton

  front = surrounding_info[0]
  next  = bug.move info

  switch next
    when 'EAT'          then eat_bug  bugs, bug, front.info, front.x, front.y
    when 'WALK_FORWARD' then walk_bug bugs, bug, front.info, front.x, front.y
    when 'TURN_LEFT'    then turn_bug bug, -1
    when 'TURN_RIGHT'   then turn_bug bug, +1

eat_bug = (bugs, bug, info, x, y) ->
  return unless info == 'OTHER'
  bugs.grid[x][y].name  = bug.name
  bugs.grid[x][y].move  = bug.move
  bugs.grid[x][y].color = bug.color

walk_bug = (bugs, bug, info, x, y) ->
  return unless info == 'EMPTY'
  bugs.grid[bug.location.x][bug.location.y] = null
  bugs.grid[x][y] = bug
  bug.location.x  = x
  bug.location.y  = y

turn_bug = (bug, offset) ->
  bug.direction = (((bug.direction + offset) % 4) + 4) % 4

add_bug_to_canvas = (canvas, bug) ->
  x   = bug.location.x * 10
  y   = bug.location.y * 10
  pos = switch bug.direction
    when 0 then left: x,      top: y,      angle:   0
    when 1 then left: x + 10, top: y,      angle:  90
    when 2 then left: x + 10, top: y + 10, angle: 180
    when 3 then left: x,      top: y + 10, angle: 270

  if bug.prev_name == bug.name
    if bug.canvas_img
      bug.canvas_img.set pos
  else
    canvas.remove(bug.canvas_img) if bug.canvas_img
    bug.prev_name = bug.name
    url = '/imgs/bugs/bug_' + bug.color + '.png'
    fabric.Image.fromURL url, (img) ->
      bug.canvas_img = img
      canvas.add img.set
        width:      10
        height:     10
        left:       pos.left
        top:        pos.top
        angle:      pos.angle
        selectable: false

render_game = (canvas, bugs) ->
  for column in bugs.grid
    for bug in column
      add_bug_to_canvas(canvas, bug) if bug?

  canvas.renderAll()

random_num = (max, min = 0) ->
  Math.floor(Math.random() * (max - min) + min)

create_fly_trap =
  (info) ->
    if info.front == 'OTHER' then 'EAT' else 'TURN_LEFT'

create_moth =
  (info) ->
    r = random_num 100

    if info.front == 'OTHER'
      'EAT'
    else if r > 4 and info.front == 'EMPTY'
      'WALK_FORWARD'
    else if r > 2
      'TURN_LEFT'
    else
      'TURN_RIGHT'


shuffle_array = (array) ->
  i = array.length
  return [] if i is 0

  while --i
      j = Math.floor(Math.random() * (i+1))
      [array[i], array[j]] = [array[j], array[i]]
