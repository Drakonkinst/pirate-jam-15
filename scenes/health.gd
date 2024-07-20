extends Node

# Multiple features in the game need a healthbar, so they should use the same common logic

class_name Health

signal health_changed(value: int) # Use to inform UI elements
signal death

var health: int
var max_health: int
var dead: bool = false

func set_max_health(value: int) -> void:
    max_health = value

func damage(value: int) -> void:
    set_health(health - value)

func kill() -> void:
    set_health(0)

func refill_health() -> void:
    set_health(max_health)

func set_health(value: int) -> void:
    if dead:
        return
    health = clamp(value, 0, max_health)
    health_changed.emit(value)
    if health <= 0:
        dead = true
        death.emit()

func get_percentage() -> float:
    return health * 1.0 / max_health
