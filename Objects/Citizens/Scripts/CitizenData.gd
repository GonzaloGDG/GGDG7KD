class_name CitizenData
extends Resource 

@export var citizen_type : CitizenType

@export var citizen_id: int
@export var citizen_name:= "Unname"
@export var age:= 18
@export var happiness := 100
@export var experience := 0
@export var level := 1
@export var max_life := 100
@export var current_life := 100

var city: City

func profession_change(p: GameResources.Profession) -> void:
	citizen_type.profession = p
	experience = 0

func add_exp(e: int) -> void:
	experience += e

	while experience >= get_next_level_exp():
		experience -= get_next_level_exp()
		level += 1
		max_life += level * 10
		current_life += 10

func get_next_level_exp() -> int:
	return level * level * 10

func get_profession_name() -> String:
	return GameResources.Profession.keys()[citizen_type.profession]

func get_gender_name() -> String:
	return GameResources.Gender.keys()[citizen_type.gender]

func add_happiness(value: int):
	happiness = clamp(happiness + value, 0, 100)
	
func damage(amount: int):
	current_life = max(current_life - amount, 0)
