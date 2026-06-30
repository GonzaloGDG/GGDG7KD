# resource_manager.gd
class_name CitizenManager
extends Node

@export var citizens: Array[CitizenData] = []

signal citizen_trained(citizen_data: CitizenData)
signal enqueue_training_item(training_entry: TrainingEntry)


#Training options
var train_option: Array[CitizenType] = [
	GameResources.BUILDER, 
	GameResources.FARMER
]

# Train Citizens
var training_queue: Array[TrainingEntry] = []
var current_training: TrainingEntry = null

func enqueue_training(entry: TrainingEntry):
	training_queue.append(entry)
	enqueue_training_item.emit(entry)
	
func remove_training(entry: TrainingEntry):
	training_queue.erase(entry)
# Train Citizens
func create_training(type: CitizenType, amount: int, time: float) -> TrainingEntry:
	var entry := TrainingEntry.new()
	entry.citizen_type = type
	entry.amount = amount
	entry.training_time = time
	entry.training_cost = type.train_cost
	return entry

func train(delta):
	if current_training == null:
		if training_queue.is_empty():
			return
		current_training = training_queue.pop_front()
	current_training.progress += delta
	if current_training.progress >= current_training.training_time:
		_finish_training()

func _finish_training():
	var idle_citizens = get_idle_citizens()
	if idle_citizens.is_empty():
		print("No idle citizens available")
		current_training = null
		return
		
	var citizen = idle_citizens.pick_random()
	citizen.citizen_type = current_training.citizen_type
	citizen_trained.emit(citizen)
	current_training.amount -= 1
	# Si aún quedan unidades por entrenar
	if current_training.amount <= 0:
		current_training = null

func add_citizen(citizen: CitizenData):
	citizens.append(citizen)

func remove_citizen(citizen: CitizenData):
	citizens.erase(citizen)

func get_population() -> int:
	return citizens.size()

func get_citizens_by_profession() -> Dictionary:
	var grouped := {}
	for citizen in citizens:
		var citizen_type = citizen.citizen_type
		if not grouped.has(citizen_type):
			grouped[citizen_type] = 1
		else:
			grouped[citizen_type] += 1
		
	return grouped
	
func get_citizens_by_one_profession(profession: GameResources.Profession) -> Array[CitizenData]:
	var result: Array[CitizenData] = []
	for citizen in citizens:
		if citizen.citizen_type.profession == profession:
			result.append(citizen)
	return result

func count_profession(profession: GameResources.Profession) -> int:
	var total := 0
	for citizen in citizens:
		if citizen.citizen_type.profession == profession:
			total += 1
	return total
#
func create_citizen(citizen_name: String,gender: GameResources.Gender) -> CitizenData:
	var citizen := CitizenData.new()
	citizen.citizen_name = citizen_name
	citizen.gender = gender
	add_citizen(citizen)
	return citizen

func get_idle_citizens() -> Array[CitizenData]:
	return get_citizens_by_one_profession(
		GameResources.Profession.IDLE
	)

func get_count_idle_citizens() -> int:
	return count_profession(
		GameResources.Profession.IDLE
	)
