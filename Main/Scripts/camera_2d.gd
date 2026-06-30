extends Camera2D

var speed = 500
var edge_margin = 20

const MARGIN = 400

func _ready():
	limit_left = -MARGIN
	limit_top = -MARGIN
	limit_right = MARGIN*2
	limit_bottom = MARGIN*3

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_size = get_viewport_rect().size
	
	var movement = Vector2.ZERO
	
	# izquierda
	if mouse_pos.x < edge_margin:
		movement.x -= 1
	# derecha	
	if mouse_pos.x > screen_size.x - edge_margin:
		movement.x += 1
	#arriba
	if mouse_pos.y < edge_margin:
		movement.y -= 1
	# derecha	
	if mouse_pos.y > screen_size.y - edge_margin:
		movement.y += 1
	
	if movement != Vector2.ZERO:
		position += movement.normalized() * speed * delta	
	
