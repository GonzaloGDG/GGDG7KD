extends StaticBody2D
class_name BuildingScene

signal update_building_info(b: BuildingScene)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var area_2d: Area2D = $Area2D

var selected = false
var workers: Array[CitizenData]

var building_type: BuildingType
var city: City
var construction_progress: float = 0.0

func setup(bt: BuildingType, c: City):
	building_type = bt
	city = c
	sprite_2d.texture = building_type.icon
	collision_shape_2d.disabled = true
	modulate.a = 0.5

func send_info()-> void:
	update_building_info.emit(self)

func set_selected(value):
	selected = value
	if selected:
		send_info()

func add_progress():
	for body in area_2d.get_overlapping_bodies():
		if body is WorldCitizenBody:
			if body.citizen.citizen_data.citizen_type.profession == GameResources.Profession.BUILDER:
				body.citizen.anim_change("Action")
				var value: float 
				value = 100/building_type.time_to_build
				construction_progress += value * body.citizen.citizen_data.level
				construction_progress = clamp(construction_progress, 0 , 100)
				progress_bar.value = construction_progress
				if construction_progress >= 100:
					progress_bar.visible = 0
					modulate.a = 1
					collision_shape_2d.disabled = false
					body.citizen.anim_change("walk")
					GameManager.buildings_on_build.erase(self)
					if GameManager.buildings_on_build.size() > 0 and GameManager.buildings_on_build[0]:
						body.move_to(GameManager.buildings_on_build[0].position)
		
