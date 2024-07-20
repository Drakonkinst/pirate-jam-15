extends Node2D

const DURATION = 2
var time_alive: float = 0

func _process(delta: float) -> void:
    time_alive += delta
    if time_alive >= DURATION:
        queue_free()
