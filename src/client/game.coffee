jitterbug_game = (canvas_id) ->
  canvas = new fabric.Canvas 'jitterbug_game_canvas',
    backgroundColor:   "#CCCCCC"
    renderOnAddRemove: false

  fabric.Object.prototype.transparentCorners = false

  canvas.setHeight  400
  canvas.setWidth  600

  canvas.add new fabric.Rect
    left: 10
    top: 10
    height: 10
    width: 10
    fill: 'rgb(255,0,0)'

  canvas.renderAll()
