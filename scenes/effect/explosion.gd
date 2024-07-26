extends Node2D

class_name Explosion

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
    sprite.play()

func set_color(color: Color) -> void:
    var alpha = sprite.modulate.a
    sprite.modulate = color
    sprite.modulate.a = alpha

func _on_animated_sprite_2d_animation_finished() -> void:
    queue_free()
