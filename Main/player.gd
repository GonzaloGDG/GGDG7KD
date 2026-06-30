extends Node
class_name Player
signal update_main_resouce(MainResourceData)

@export var player_name: String
@export var gold: int
@export var reputation: int
@export var cities: Array[City]

func modify_gold(amount: int) -> void:
	gold += amount
	update_main_resouce.emit(self)

func modify_reputation(amount: int) -> void:
	reputation += amount
	update_main_resouce.emit(self)
	
func turn():
	for city in cities:
		city.turn_gold()
		city.turn_resources()
