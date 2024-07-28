extends Node2D

# Based on https://youtu.be/r-pd2yuNPvA?t=1037

class_name LightGlow

@export var sprite: Sprite2D
@export var noise: FastNoiseLite
@export var speed: float = 20.0
@export var max_bonus: float = 0.5

var original_scale: Vector2
var time: float = 0.0

func _ready() -> void:
    time = randf_range(0.0, 1000.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    time += delta * speed
    sprite.scale = original_scale * (1.0 + noise.get_noise_1d(time) * max_bonus)