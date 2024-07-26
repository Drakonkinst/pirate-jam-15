extends Node2D

class_name Splat

const MAX_OPACITY := 0.3
const MIN_OPACITY := 0.0
const FADE_TIME := 1
const LIFE_TIME := 1.75
const MIN_SCALE := 0.5
const MAX_SCALE := 1
const SCALE_TIME := 0.05

@export var sprite_options: Array[Texture2D]
@onready var sprite: Sprite2D = $Sprite2D
var age: float = 0.0

func _ready() -> void:
    sprite.texture = sprite_options[randi() % sprite_options.size()]
    sprite.modulate.a = MAX_OPACITY

# Change tint color without modifying alpha
func set_color(color: Color) -> void:
    var alpha = sprite.modulate.a
    sprite.modulate = color
    sprite.modulate.a = alpha

func _process(delta: float) -> void:
    age += delta

    var current_scale = MIN_SCALE + (MAX_SCALE - MIN_SCALE) * min(1.0, age / SCALE_TIME)
    sprite.scale = Vector2(current_scale, current_scale)

    if age >= LIFE_TIME:
        queue_free()
    elif age >= LIFE_TIME - FADE_TIME:
        var progress: float = 1 - (age - (LIFE_TIME - FADE_TIME)) / FADE_TIME
        sprite.modulate.a = MIN_OPACITY + (MAX_OPACITY - MIN_OPACITY) * progress