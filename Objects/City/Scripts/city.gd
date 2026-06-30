extends Node2D
class_name City

signal update_city_info(c: City)
signal build(building_type: BuildingType)

@export var city_name: String
@onready var icon: Sprite2D = $Area2D/Image
@onready var player: Player
@export var tax_level: GameResources.TaxLevel = GameResources.TaxLevel.MEDIUM

@onready var resource_manager: ResourceManager = $ResourceManager
@onready var citizen_manager : CitizenManager = $CitizenManager
@onready var building_manager: Node2D = $BuildingManager

var selected = false

func _process(delta):
	citizen_manager.train(delta)

func send_info()-> void:
	update_city_info.emit(self)
	
func set_selected(value):
	selected = value
	if selected:
		send_info()

func emit_build_signal(building_type: BuildingType)-> void:
	build.emit(building_type, self)

func turn_gold():
	var gold_expend: int = 0
	var gold_income: int = 0
	for citizen in citizen_manager.citizens:
		gold_expend += citizen.citizen_type.maintenance_cost
		if citizen.citizen_type.pay_taxes:
			gold_income += tax_level
	for building in building_manager.builded:
		gold_expend += building.building_type.maintenance_cost	
	player.modify_gold(gold_income - gold_expend)		

func turn_resources():
	food_eated_by_turn()
	for building: BuildingScene in building_manager.builded:
		for resource in building.building_type.resources:
			var resource_data : ResourceData = resource
			var quantity : int = building.workers.size() * building.building_type.resource_per_worker
			
			resource_manager.add_resource(resource_data,quantity)

# Food eated by turn
func food_eated_by_turn():
	var resource_data : ResourceData
	resource_data = GameResources.WHEAT	
	resource_manager.add_resource(resource_data,-citizen_manager.get_population())
