extends Node

#Resources
const WHEAT = preload("res://Resources/CityResources/wheat.tres")
const TOOLS = preload("res://Resources/CityResources/tools.tres")
const WOOD = preload("res://Resources/CityResources/wood.tres")
const IRON = preload("res://Resources/CityResources/iron.tres")

#Ciotizens
const IDLE = preload("res://Objects/Citizens/Resources/Idle.tres")
const KING = preload("res://Objects/Citizens/Resources/King.tres")
const FARMER = preload("res://Objects/Citizens/Resources/Farmer.tres")
const BUILDER = preload("res://Objects/Citizens/Resources/Builder.tres")

#Buildings
const FARM = preload("res://Objects/Buildings/Resources/Farm.tres")

enum Profession {
	IDLE,
	FARMER,
	BUILDER,
	SOLDIER,
	MINER,
	FISHER,
	CATTLEMAN,
	WEAVER,
	KING
}

enum WorldCitizenActions {
	BUILD,
}

enum Buildings {
	FARM,
}

enum CityResources {
	WHEAT,
	TOOLS,
	WOOD,
	IRON
}

enum Gender {MALE,FEMALE}

enum TaxLevel {FREE, LOW, MEDIUM, HIGHT, PUNITIVE}
