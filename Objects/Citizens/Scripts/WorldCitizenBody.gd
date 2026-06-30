extends CharacterBody2D
class_name WorldCitizenBody

var has_target := false
var target_position := Vector2.ZERO
var speed = 50

const ANIM_IDLE = "Idle"
const ANIM_WALK = "walk"	
var enter_buiding: bool = false

@onready var citizen: WorldCitizen = get_parent()

func move_to(pos):
	target_position = pos
	has_target = true

func _process(_delta):
	z_index = int(global_position.y + 1000)
func _physics_process(_delta):
	if has_target:
		var direction = (target_position - global_position)
		
		if direction.length() > 5:
			velocity = direction.normalized() * speed 
			move_and_slide()
			citizen.anim_change(ANIM_WALK)

		else:
			velocity = Vector2.ZERO
			has_target = false
			citizen.anim_change(ANIM_IDLE)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var objeto = collision.get_collider()
		if objeto is BuildingScene:
			if objeto.building_type.worker_type == citizen.citizen_data.citizen_type.profession:
				if objeto.workers.size() < objeto.building_type.max_workers:
					if enter_buiding:
						return
					enter_buiding = true
					objeto.workers.append(citizen.citizen_data)
					GameManager.selected_citizens.erase(citizen)
					citizen.queue_free()
					GameManager.selected_building = objeto
					GameManager.selected_building.send_info()
