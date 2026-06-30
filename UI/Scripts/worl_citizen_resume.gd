extends Control

@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect
@onready var label: Label = $VBoxContainer/Label
@onready var life_progres_bar: TextureProgressBar = $VBoxContainer/lifeProgresBar

func setup(wc: WorldCitizen):
	texture_rect.texture = wc.get_icon()
	label.text = wc.get_citizen_profession()
