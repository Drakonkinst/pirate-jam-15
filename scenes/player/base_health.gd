extends Control

class_name BaseHealth

signal game_over

@onready var health: Health = $Health

func _ready() -> void:
    health.set_max_health(125)
    health.set_health(125)

func damage(amount: int) -> void:
    # TODO: Play sound or something idk
    health.damage(amount)

func _on_health_death() -> void:
    game_over.emit()

func _on_health_changed(value: int, percent: float, instant: bool) -> void:
    pass