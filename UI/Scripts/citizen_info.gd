extends NinePatchRect

const WORLD_CITIZEN_ACTION_BUTTON = preload("res://UI/WorldCitizenActionButton.tscn")

func update(wc: WorldCitizen) -> void:
	self.visible = true
	$NinePatchRect/job.text = wc.get_citizen_profession()
	$NinePatchRect/level.text = "Level: " + wc.get_citizen_level()
	$NinePatchRect/icon/image.texture = wc.get_icon()
	$NinePatchRect/Name.text = wc.get_citizen_name()
	
	for child in $NinePatchRect/Actions.get_children():
		child.queue_free()
	
	for action in wc.citizen_data.citizen_type.actions:
		var action_button = WORLD_CITIZEN_ACTION_BUTTON.instantiate()
		$NinePatchRect/Actions.add_child(action_button)
		action_button.setup(action)
