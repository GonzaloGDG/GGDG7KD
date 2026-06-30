extends Node2D

@onready var units = $units
@onready var cities = $cities
@onready var buildings: Node2D = $buildings


signal city_created(city)
signal citizen_created(citizen)

var building_to_place: BuildingScene

const WORLD_CITIZEN_SCENE = preload("res://Objects/Citizens/WorldCitizen.tscn")
const CITY_SCENE = preload("res://Objects/City/city.tscn")
const BUILDING_SCENE = preload("res://Objects/Buildings/BuildingScene.tscn")

func select_object(mouse_pos):

	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()

	query.position = mouse_pos
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var result = space_state.intersect_point(query)
	for hit in result:
		var obj = hit.collider
		if obj.get_parent().has_method("set_selected"):
			obj.get_parent().set_selected(true)
			return obj.get_parent()
	return null
	
func create_world_citizen(citizen_name: String, citizen_type: CitizenType, pos: Vector2, city: City) -> void:
	var citizen_data := CitizenData.new()
	citizen_data.citizen_name = citizen_name
	citizen_data.citizen_type = citizen_type
	citizen_data.city = city
	var citizen := WORLD_CITIZEN_SCENE.instantiate()
	citizen.citizen_data = citizen_data
	citizen.position = pos
	units.add_child(citizen)
	city.citizen_manager.add_citizen(citizen_data)
	citizen_created.emit(citizen)
	
func create_city(city_name: String, population: int, pos: Vector2, player: Player) -> City:

	var city = CITY_SCENE.instantiate()
	city.city_name = city_name
	city.position = pos
	city.player = player
	cities.add_child(city)
	city_created.emit(city)
	city.resource_manager.add_resource(GameResources.WHEAT,50)
	city.resource_manager.add_resource(GameResources.WOOD,20)
	city.resource_manager.add_resource(GameResources.TOOLS,5)
	city.resource_manager.add_resource(GameResources.IRON,10)
	city.citizen_manager.citizen_trained.connect(_on_citizen_trained)
	
	for i in range(population):
		var citizen := CitizenData.new()
		citizen.citizen_name = "Citizen_%s" % i
		citizen.citizen_type = GameResources.IDLE
		citizen.city = city
		city.citizen_manager.add_citizen(citizen)
	
	return city

func _on_citizen_trained(citizen_data: CitizenData):
	var citizen = WORLD_CITIZEN_SCENE.instantiate()
	citizen.citizen_data = citizen_data
	for marker in citizen.citizen_data.city.citizen_manager.get_children():
		if is_position_free(marker.global_position):
			citizen.position = marker.global_position
			#citizen.update_character_info.connect(citizen_info.update)
			units.add_child(citizen)
			citizen_created.emit(citizen)
			break
	
func is_position_free(pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(32, 32)
	query.shape = rect
	query.transform.origin = pos
	query.collision_mask = 0xFFFFFFFF
	var result = space_state.intersect_shape(query)
	return result.is_empty()

func on_building(building_type: BuildingType, city: City, pos: Vector2):
	var building := BUILDING_SCENE.instantiate()
	building.position = pos
	buildings.add_child(building)
	building.setup(building_type, city)
	building_to_place = building

func build() -> BuildingScene:
	building_to_place.city.resource_manager.consume_resource(building_to_place.building_type.cost)
	building_to_place.city.building_manager.builded.append(building_to_place)
	GameManager.buildings_on_build.append(building_to_place)
	GameManager.selected_citizens[0].move_to(building_to_place.position)
	return building_to_place

func not_build():
	building_to_place.queue_free()
	
