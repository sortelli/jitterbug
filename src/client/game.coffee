jitterbug_game = (canvas_id) ->
  canvas = new fabric.Canvas 'jitterbug_game_canvas',
    backgroundColor:   "#CCCCCC"
    renderOnAddRemove: false

  fabric.Object.prototype.transparentCorners = false

  canvas.setHeight  400
  canvas.setWidth  600

  turns = 0
  bugs  = starting_bugs
  render_game canvas, bugs

  next_turn bugs, canvas, turns

next_turn = (bugs, canvas, turns) ->
  bugs = next_iteration bugs
  render_game canvas, bugs

  if turns < 1000
    setTimeout((-> next_turn bugs, canvas, turns + 1), 10)

starting_bugs = ->
  []

next_iteration = (bugs) ->
  bugs

render_game = (canvas, bugs) ->
  canvas.clear()

  canvas.add new fabric.Rect
    left:   random_num(600 - 10)
    top:    random_num(400 - 10)
    height: 10
    width:  10
    fill:   'rgb(255,0,0)'

  canvas.renderAll()

random_num = (max, min = 0) ->
  Math.floor(Math.random() * (max - min) + min)
