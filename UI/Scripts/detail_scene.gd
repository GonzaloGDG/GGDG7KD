extends Control

@export var icon: TextureRect
@export var amount: Label

func setup(texture: Texture2D, a: int):
	icon.texture = texture
	amount.text = str(a)
