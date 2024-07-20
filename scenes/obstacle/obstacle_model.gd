extends Node2D

class_name ObstacleModel

@onready var model: Sprite2D = $Base
@onready var flaming_sprite: AnimatedSprite2D = $Flaming

@export var burnt_material: Material

@export var transmutable_map: Array[TransmutableEntry]

var original_texture: Texture

func _ready() -> void:
    original_texture = model.texture

func set_flaming(is_on_fire: bool) -> void:
    flaming_sprite.visible = is_on_fire

func set_burned_overlay() -> void:
    model.material = burnt_material

func set_transmuted_state(state: Obstacle.TransmutedState) -> bool:
    # Replacing the material will always clear the burned state
    model.material = null

    for entry: TransmutableEntry in transmutable_map:
        if entry.state == state:
            model.texture = entry.texture
            return true
    model.texture = original_texture
    return false