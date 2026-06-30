extends Button

var citizen_type: CitizenType

func setup(train: CitizenType):
	tooltip_text = GameResources.Profession.keys()[train.profession].capitalize()
	icon = train.icon
	citizen_type = train

func _pressed():
	if (GameManager.selected_city.citizen_manager.training_queue.size() <
		GameManager.selected_city.citizen_manager.get_count_idle_citizens() - 1):
		var training_entry: TrainingEntry
		training_entry = GameManager.selected_city.citizen_manager.create_training(citizen_type,1,5.0)
		GameManager.selected_city.citizen_manager.enqueue_training(training_entry)
		GameManager.selected_city.player.modify_gold(-training_entry.training_cost)
