extends Node2D
#Main Screen
#Control the inputs
#Conect the signals betwen UI, Map, and Objects


@onready var objects = $World/objects
@onready var citizen_info: Control = $CanvasLayer/Ui/CitizenInfo
@onready var city_info: Control = $CanvasLayer/Ui/CityInfo
@onready var building_info: Control = $CanvasLayer/Ui/BuildingInfo
@onready var city_detail_panel: Control = $CanvasLayer/Ui/CityDetailPanel
@onready var selection_box: Node2D = $SelectionBox
@onready var camera: Camera2D = $World/Camera2D
@onready var ui: Control = $CanvasLayer/Ui
@onready var player: Player = $Player

var on_build: bool = false

func _ready():
	
	objects.city_created.connect(_on_city_created)
	objects.citizen_created.connect(_on_citizen_created)
	var city = objects.create_city("Algorta",10,Vector2(100, 40),player)
	objects.create_world_citizen("Marcus",GameResources.KING,Vector2(50, 50),city)
	objects.create_world_citizen("Manolillo",GameResources.BUILDER,Vector2(90, 90),city)
	player.cities.append(city)
	player.modify_gold(1000)
	player.modify_reputation(10)
	player.update_main_resouce.connect(ui.update_resources)

func _process(_delta):
	if on_build:
		objects.building_to_place.global_position = get_global_mouse_position()

func _on_city_created(city):
	city.update_city_info.connect(city_info.update)
	city.build.connect(_build)

func _on_citizen_created(citizen):
	citizen.update_character_info.connect(citizen_info.update)
	citizen.action_button_press.connect(_execute_citizen_action)

func _on_building_created(building):
	building.update_building_info.connect(_building_info_update)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if on_build:
				if _is_free_to_place():
					if GameManager.selected_city.building_manager.can_build(get_global_mouse_position()):
						on_build = false
						GameManager.selected_city.building_manager.on_build = false
						GameManager.selected_city.building_manager.queue_redraw()
						_on_building_created(objects.build())
						objects.building_to_place = null
	
func _unhandled_input(event):
	
	if event is InputEventMouseMotion:
		if selection_box.dragging:
			selection_box.current = get_global_mouse_position()

	if event is InputEventMouseButton:
		var mouse_world = get_global_mouse_position()
		if event.button_index == MOUSE_BUTTON_LEFT:
			if on_build:
				return
			else:
				if event.pressed:
					selection_box.dragging = true
					selection_box.start = mouse_world
					selection_box.current = mouse_world
				else:
					selection_box.dragging = false
					selection_box.current = mouse_world
					var drag_distance = (selection_box.current - selection_box.start).length()
					if drag_distance < 10:
						_clear_selection()
						var obj = objects.select_object(mouse_world)
						if obj == null:
							return
						#print(obj.get_class())
						#print(obj.get_script().get_global_name())
						if obj is City:
							GameManager.selected_city = obj
						elif obj is BuildingScene:
							GameManager.selected_building = obj
						elif obj is WorldCitizen:
							GameManager.selected_citizens.append(obj)
					else:
						select_units_in_rect()
		elif event.button_index == MOUSE_BUTTON_RIGHT \
		and event.pressed:
			
			if on_build:
				on_build = false
				objects.not_build()
			else:
				for citizen in GameManager.selected_citizens:
					citizen.move_to(mouse_world)

func select_units_in_rect():

	_clear_selection()

	var rect = Rect2(selection_box.start,selection_box.current - selection_box.start).abs()
	for obj in objects.units.get_children():
		if obj is WorldCitizen:
			if rect.has_point(obj.body.global_position):
				GameManager.selected_citizens.append(obj)
				obj.set_selected(true)
	if GameManager.selected_citizens.size() == 1:
		citizen_info.update(GameManager.selected_citizens[0])
	else:
		ui.on_several_units_selected()				

func _clear_selection():
	if GameManager.selected_city:
		GameManager.selected_city.set_selected(false)

	for citizen in GameManager.selected_citizens:
		citizen.set_selected(false)
	
	if GameManager.selected_building:	
		GameManager.selected_building.set_selected(false)
	GameManager.selected_citizens.clear()

	GameManager.selected_city = null

	city_info.visible = false
	citizen_info.visible = false
	building_info.visible = false
	city_detail_panel.visible = false

func _execute_citizen_action(action: GameResources.WorldCitizenActions):
	if action == GameResources.WorldCitizenActions.BUILD:
		ui.building_detail()

func _build(building: BuildingType, city: City):
	on_build = true
	objects.on_building(building,city,get_global_mouse_position())
	GameManager.selected_city = city
	GameManager.selected_city.building_manager.on_build = true
	GameManager.selected_city.building_manager.queue_redraw()

func _on_timer_timeout() -> void:
	for building in GameManager.buildings_on_build:
		building.add_progress()
	
func _building_info_update(bt: BuildingScene) -> void:
	_clear_selection()
	building_info.update(bt)

func _is_free_to_place() -> bool:
	if objects.building_to_place.area_2d.get_overlapping_bodies().size() > 0:
		return false
	return true


func _on_turn_timeout() -> void:
	player.turn()
