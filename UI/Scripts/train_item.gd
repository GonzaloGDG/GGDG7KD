extends Control

signal remove_requested(entry: TrainingEntry)

var train_entry: TrainingEntry

@export var icon: TextureRect
@export var progress_bar: ProgressBar

func setup(te: TrainingEntry):
	tooltip_text = GameResources.Profession.keys()[te.citizen_type.profession].capitalize()
	icon.texture = te.citizen_type.icon
	train_entry = te

func _process(_delta):
	if train_entry == null:
		return
	progress_bar.value = (train_entry.progress/train_entry.training_time) * 100.0 

func _gui_input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_RIGHT \
		and event.pressed:

			remove_requested.emit(train_entry)
