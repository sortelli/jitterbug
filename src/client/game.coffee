jitterbug_game = (canvas_id) ->
  canvas = new fabric.Canvas 'jitterbug_game_canvas',
    backgroundColor:   "#CCCCCC"
    renderOnAddRemove: false

  fabric.Object.prototype.transparentCorners = false

  canvas.setHeight  400
  canvas.setWidth  600

  turns = 0
  bugs  = starting_bugs()
  render_game canvas, bugs

  next_turn bugs, canvas, turns

next_turn = (bugs, canvas, turns) ->
  next_iteration bugs
  render_game canvas, bugs

  if turns < 10
    setTimeout((-> next_turn bugs, canvas, turns + 1), 100)

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
    next_color:  [
      'rgb(0,255,0)'
      'rgb(255,0,0)'
      'rgb(0,0,255)'
    ]

  add_bug bugs, 'fly_trap', create_fly_trap
  add_bug bugs, 'fly_trap', create_fly_trap
  add_bug bugs, 'fly_trap', create_fly_trap

  add_bug bugs, 'moth', create_moth
  add_bug bugs, 'moth', create_moth
  add_bug bugs, 'moth', create_moth

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
    direciton: direction
    location:  location
    color:     color
    serial:    (bugs.next_serial += 1)

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

  console.log 'end iteration'

move_bug = (bugs, bug) ->
  x = bug.location.x
  y = bug.location.y

  bug.location.x = x + 1
  bug.location.y = y + 1

render_game = (canvas, bugs) ->
  canvas.clear()

  for column in bugs.grid
    for bug in column
      if bug?
        canvas.add new fabric.Rect
          left:   bug.location.x * 10
          top:    bug.location.y * 10
          height: 10
          width:  10
          fill:   bug.color

  canvas.renderAll()

random_num = (max, min = 0) ->
  Math.floor(Math.random() * (max - min) + min)

create_fly_trap =
  (info) ->
    if info.front == 'OTHER' then 'EAT' else 'TURN_LEFT'

create_moth =
  (info) ->
    if info.front == 'OTHER'
      'EAT'
    else if info.front == 'EMPTY'
      'WALK_FORWARD'
    else
      'TURN_LEFT'

shuffle_array = (array) ->
  i = array.length
  return [] if i is 0

  while --i
      j = Math.floor(Math.random() * (i+1))
      [array[i], array[j]] = [array[j], array[i]]
