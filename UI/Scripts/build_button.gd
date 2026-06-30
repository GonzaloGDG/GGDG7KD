extends Control

var building_type: BuildingType
@onready var button: Button = $VBoxContainer/Button
@onready var label: Label = $VBoxContainer/Label

func _ready():
	button.pressed.connect(_on_button_pressed)
	
func setup(type: BuildingType):
	building_type = type
	label.text = building_type.buiding_name
	button.icon = building_type.icon
	for cost in building_type.cost:
		button.tooltip_text += "%s: %s\n" % [cost.resource_data.display_name,cost.quantity]

func _on_button_pressed():
	
	var city : City = GameManager.selected_citizens[0].citizen_data.city
	
	var can_afford = city.resource_manager.can_afford(building_type.cost)
	if can_afford:
		city.emit_build_signal(building_type)
