extends Node2D

class_name PlayerResources

@export var gold: int
@export var fire_crystals: int
@export var amber_sap: int
@export var fruit: int
@export var quartz: int

var inventory: Dictionary

func initialize() -> void:
	for i in Pickup.PickupType.keys().size():
		set_count(i, 0)

func get_count(type: Pickup.PickupType) -> int:
	return inventory[type]

func add_count(type: Pickup.PickupType, value = 1) -> void:
	var current_count = get_count(type)
	set_count(type, current_count + value)

func set_count(type: Pickup.PickupType, value: int) -> void:
	inventory[type] = value
