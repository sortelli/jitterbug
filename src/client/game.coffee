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

  #next_turn bugs, canvas, turns

next_turn = (bugs, canvas, turns) ->
  bugs = next_iteration bugs
  render_game canvas, bugs

  if turns < 1000
    setTimeout((-> next_turn bugs, canvas, turns + 1), 10)

starting_bugs = ->
  grid = []

  for x in [0..59]
    grid[x] = []
    for y in [0..39]
      grid[x][y] = null

  bugs = grid: grid


  add_bug bugs, 'fly_trap', 'rgb(0,0,255)', create_fly_trap
  add_bug bugs, 'fly_trap', 'rgb(0,0,255)', create_fly_trap
  add_bug bugs, 'fly_trap', 'rgb(0,0,255)', create_fly_trap

  bugs

add_bug = (bugs, name, color, move) ->
  location  = random_location bugs
  direction = random_num 3

  bugs.grid[location.x][location.y] =
    move:      move
    name:      name
    direciton: direction
    location:  location
    color:     color

random_location = (bugs) ->
  x = random_num 59
  y = random_num 39

  if (bugs.grid[x][y]?)
    random_location bugs
  else
    x: x, y: y

next_iteration = (bugs) ->
  bugs

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
