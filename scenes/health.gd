extends Node

# Multiple features in the game need a healthbar, so they should use the same common logic

class_name Health

signal on_health_changed # Use to inform UI elements

var health: int
var max_health: int

func set_max_health(value: int) -> void:
    max_health = value

func set_health(value: int) -> void:
    health = clamp(value, 0, max_health)

func get_percentage() -> float:
    return health * 1.0 / max_health
