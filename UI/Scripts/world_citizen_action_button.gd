extends Button

var action: GameResources.WorldCitizenActions

const TOOLS = preload("res://Resources/Iconos/tools.png")

func setup(a: GameResources.WorldCitizenActions):
	action = a
	if action == GameResources.WorldCitizenActions.BUILD:
		tooltip_text = "BUILD"
		icon = TOOLS

func _pressed():
	if action == GameResources.WorldCitizenActions.BUILD:
		GameManager.selected_citizens[0].execute_action(action)
