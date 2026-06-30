# Class to control experience of a citizen
extends Node2D
class_name WorldCitizen

signal action_button_press(action: GameResources.WorldCitizenActions)
signal update_character_info(wc: WorldCitizen)

@onready var anim: AnimationTree = $CharacterBody2D/AnimationTree
@onready var icon: Sprite2D = $CharacterBody2D/Image
@onready var body: CharacterBody2D = $CharacterBody2D

@export var citizen_data: CitizenData

var portrait: AtlasTexture
var selected = false
var current_anim := ""

func _ready() -> void:
	_setup_portrait()
	_update_texture()

func _setup_portrait() -> void:
	if icon.texture == null:
		return
	portrait = AtlasTexture.new()
	portrait.atlas = icon.texture
	portrait.region = Rect2(0, 0, 32, 32)

func set_selected(value: bool):
	selected = value
	$CharacterBody2D/Selector.visible = value
	if selected:
		send_info()

func move_to(pos: Vector2) -> void:
	body.move_to(pos)

func anim_change(state: String) -> void:
	if current_anim == state:
		return
	current_anim = state
	anim["parameters/conditions/idle"] = (
		state == "Idle"
	)
	anim["parameters/conditions/walk"] = (
		state == "walk"
	)
	
	anim["parameters/conditions/action"] = (
		state == "Action"
	)

func send_info()-> void:
	update_character_info.emit(self)

func get_icon() -> Texture2D:
	#return portraitk
	return citizen_data.citizen_type.icon
	
func get_citizen_name() -> String:
	if citizen_data == null:
		return "Unknown"
	return citizen_data.citizen_name

func get_citizen_profession() -> String:
	if citizen_data == null:
		return "Unknown"
	return citizen_data.get_profession_name()

func get_citizen_level() -> String:
	if citizen_data == null:
		return "Unknown"
	return str(citizen_data.level)

func add_exp(e: int) -> void:
	if citizen_data == null:
		return
	citizen_data.add_exp(e)

#func change_profession(profession: CitizenData.Profession) -> void:
	#if citizen_data == null:
		#return
	#citizen_data.profession_change(profession)

func damage(amount: int) -> void:
	if citizen_data == null:
		return
	citizen_data.current_life = max(
		citizen_data.current_life - amount,
		0
	)
	if citizen_data.current_life <= 0:
		die()

func heal(amount: int) -> void:
	if citizen_data == null:
		return
	citizen_data.current_life = min(
		citizen_data.current_life + amount,
		citizen_data.max_life
	)

func die() -> void:
	queue_free()

func _update_texture() -> void:
	var profession_name := citizen_data.get_profession_name().to_upper()

	var path := "res://Assets/Units/%s.png" % profession_name

	if ResourceLoader.exists(path):
		icon.texture = load(path)
		_setup_portrait()
	else:
		push_warning("No existe textura: " + path)
		icon.texture = load("res://Assets/Units/IDLE.png")
		_setup_portrait()

func execute_action(action: GameResources.WorldCitizenActions):
	action_button_press.emit(action)
	
