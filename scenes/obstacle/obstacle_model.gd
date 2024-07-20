extends Node2D

class_name ObstacleModel

@onready var model: Sprite2D = $Base
@onready var flaming_sprite: AnimatedSprite2D = $Flaming

func set_flaming(flag: bool) -> void:
    flaming_sprite.visible = flag