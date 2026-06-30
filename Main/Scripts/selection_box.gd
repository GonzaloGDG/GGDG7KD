extends Node2D

var dragging := false
var start := Vector2.ZERO
var current := Vector2.ZERO

func _ready():
	z_index = 999

func _process(_delta):
	queue_redraw()

func _draw():
	if !dragging:
		return
	var rect = Rect2(to_local(start),to_local(current) - to_local(start)).abs()
	draw_rect(rect, Color(0, 1, 0, 0.2), true)
	draw_rect(rect, Color.GREEN, false, 2.0)
