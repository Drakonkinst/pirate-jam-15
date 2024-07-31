extends Node2D

class_name PotionFill

@onready var fill_potion: AnimatedSprite2D = $FillPotion

func set_tint(color: Color) -> void:
    fill_potion.modulate = color

func play() -> void:
    fill_potion.show()
    fill_potion.frame = 0
    fill_potion.play()

func _on_fill_potion_animation_finished() -> void:
    fill_potion.hide()
