extends Control

var building_scene: BuildingScene
@onready var button: Button = $VBoxContainer/Button
@onready var type: Label = $VBoxContainer/Type
@onready var workers: Label = $VBoxContainer/Workers

func _ready():
	button.pressed.connect(_on_button_pressed)
	
func setup(scene: BuildingScene):
	building_scene = scene
	type.text = scene.building_type.buiding_name
	button.icon = scene.building_type.icon
	workers.text = str(scene.workers.size()) + "/" + str(scene.building_type.max_workers)

func _on_button_pressed():
	GameManager.selected_building = building_scene
	building_scene.send_info()
