class_name BuildingType
extends Resource 

@export var type: GameResources.Buildings
@export var buiding_name: String
@export var icon: Texture2D
@export var cost: Array[ResourceQuantity]
@export var time_to_build: float
@export var worker_type: GameResources.Profession
@export var worker_icon: Texture2D
@export var max_workers: int = 2
@export var resources: Array[ResourceData]
@export var resource_per_worker: int
@export var maintenance_cost: int
