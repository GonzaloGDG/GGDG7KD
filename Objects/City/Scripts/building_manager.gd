extends Node2D

var buildings_to_Build : Array[BuildingType] = [GameResources.FARM]

var builded : Array[BuildingScene] = []

@export var build_radius := 200.0 # en pixeles

var on_build: bool = false

func can_build(build_pos: Vector2) -> bool:
	return global_position.distance_squared_to(build_pos) <= build_radius * build_radius

func _draw():
	if on_build:
		draw_circle(Vector2.ZERO, build_radius, Color(0, 1, 0, 0.2))
