class_name CitizenType
extends Resource 

@export var gender: GameResources.Gender
@export var profession: GameResources.Profession
@export var train_cost: int
@export var icon: Texture2D
@export var maintenance_cost := 0
@export var pay_taxes : bool = true

@export var actions: Array[GameResources.WorldCitizenActions] = []
