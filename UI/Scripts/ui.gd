extends Control

@export var gold_label : Label
@export var reputation_label : Label
@export var right_panel_description : NinePatchRect
@onready var detail_panel : NinePatchRect = $CityDetailPanel
@onready var detail_grid : GridContainer = $CityDetailPanel/CityDetail/MarginContainer/GridContainer



const DETAIL_SCENE = preload("res://UI/DetailScene.tscn")
const TRAIN_BUTTON = preload("res://UI/TrainButton.tscn")
const TRAIN_ITEM = preload("res://UI/train_item.tscn")
const WORLD_CITIZEN = preload("res://UI/worl_citizen_resume.tscn")
const BUILD_BUTTON = preload("res://UI/BuildButton.tscn")
const CITY_BUILDING_BUTTON = preload("res://UI/CityBuildingButton.tscn")

func update_resources(resources: Player):
	gold_label.text = str(resources.gold)
	reputation_label.text = str(resources.reputation)

func _clear_city_detail_panel() -> void:
	detail_panel.visible = !detail_panel.visible
	#if GameManager.selected_city == null:
		#return
	# Limpiar grid
	for child in detail_grid.get_children():
		child.queue_free()

func _on_market_button_pressed() -> void:

	_clear_city_detail_panel()
	detail_grid.columns = 4
	for resource in (GameManager.selected_city.resource_manager.get_all_resources()):
		var item = DETAIL_SCENE.instantiate()
		var resource_data: ResourceData = (resource["type"])
		var amount: int = (resource["amount"])
		detail_grid.add_child(item)
		item.setup(resource_data.icon,amount)
		item.tooltip_text = resource_data.display_name

func _on_citizens_button_pressed() -> void:
	
	_clear_city_detail_panel()
	detail_grid.columns = 5
	var professions = GameManager.selected_city.citizen_manager.get_citizens_by_profession()
	
	for data in professions:
		var item = DETAIL_SCENE.instantiate()
		detail_grid.add_child(item)
		item.setup(data.icon,professions[data])
		item.tooltip_text = GameResources.Profession.keys()[data.profession].capitalize()
		
func _on_train_button_pressed() -> void:
	_clear_city_detail_panel()
	detail_grid.columns = 7
	var citizen_manager = GameManager.selected_city.citizen_manager
	if not citizen_manager.enqueue_training_item.is_connected(_on_enqueue_training_item):
		citizen_manager.enqueue_training_item.connect(_on_enqueue_training_item)
	for train in GameManager.selected_city.citizen_manager.train_option:
		var button = TRAIN_BUTTON.instantiate()
		detail_grid.add_child(button)
		button.setup(train)
	
	if GameManager.selected_city.citizen_manager.current_training:
		var train_item = TRAIN_ITEM.instantiate()
		detail_grid.add_child(train_item)
		train_item.setup(GameManager.selected_city.citizen_manager.current_training)
	
	for training_entry in GameManager.selected_city.citizen_manager.training_queue:
		var train_item = TRAIN_ITEM.instantiate()
		detail_grid.add_child(train_item)
		train_item.setup(training_entry)

func _on_enqueue_training_item(train_entry: TrainingEntry):
	var train_item = TRAIN_ITEM.instantiate()
	detail_grid.add_child(train_item)
	train_item.setup(train_entry)
	train_item.remove_requested.connect(_on_remove_training_requested)

func _on_remove_training_requested(entry: TrainingEntry):
	GameManager.selected_city.citizen_manager.remove_training(entry)
	_on_train_button_pressed()

func on_several_units_selected() -> void:
	_clear_city_detail_panel()
	detail_grid.columns = 7
	for citizen: WorldCitizen in GameManager.selected_citizens:
		var worl_citizen = WORLD_CITIZEN.instantiate()
		detail_grid.add_child(worl_citizen)
		worl_citizen.setup(citizen)
	
func building_detail() -> void:
	_clear_city_detail_panel()
	detail_grid.columns = 7
	for building: BuildingType in GameManager.selected_citizens[0].citizen_data.city.building_manager.buildings_to_Build:
		var build_button = BUILD_BUTTON.instantiate()
		detail_grid.add_child(build_button)
		build_button.setup(building)


func _on_building_button_pressed() -> void:
	_clear_city_detail_panel()
	detail_grid.columns = 3
	for building: BuildingScene in GameManager.selected_city.building_manager.builded:
		var city_building_button = CITY_BUILDING_BUTTON.instantiate()
		detail_grid.add_child(city_building_button)
		city_building_button.setup(building)


func _on_option_button_item_selected(index: int) -> void:
	GameManager.selected_city.tax_level = GameResources.TaxLevel.find_key(index)
