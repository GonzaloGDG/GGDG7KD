# resource_manager.gd
class_name ResourceManager
extends Node

@export var resources := {}

func add_resource(type: ResourceData, amount: int):
	resources[type] = resources.get(type, 0) + amount

func consume_resource(rq: Array[ResourceQuantity]) -> bool:
	for res in rq:
		var type = res.resource_data
		if get_resource(type) < res.quantity:
			return false
		
		resources[res.resource_data] -= res.quantity
		
	return true

func get_resource(type: ResourceData) -> int:
	return resources.get(type, 0)

func can_afford(rq: Array[ResourceQuantity]) -> bool:
	for res in rq:
		var type = res.resource_data
		if get_resource(type) < res.quantity:
			return false

	return true

func get_all_resources() -> Array:

	var result := []

	for type in resources:

		result.append({
			"type": type,
			"amount": resources[type]
		})

	return result
