extends Node2D

class_name ObstacleModel

@onready var model: Sprite2D = $Base
@onready var flaming_sprite: AnimatedSprite2D = $Flaming

@export var burnt_material: Material

@export var transmutable_map: Array[TransmutableEntry]

var original_texture: Texture
var is_burned: bool = false

func _ready() -> void:
    original_texture = model.texture

func set_flaming(is_on_fire: bool, should_use_burnt_texture: bool) -> void:
    if is_burned or (is_on_fire and should_use_burnt_texture):
        model.material = burnt_material
        is_burned = true
    else:
        model.material = null
    flaming_sprite.visible = is_on_fire

func set_transmuted_state(state: Obstacle.TransmutedState) -> bool:
    # Replacing the material will always clear the burned state
    if is_burned:
        model.material = null
        is_burned = false

    for entry: TransmutableEntry in transmutable_map:
        if entry.state == state:
            model.texture = entry.texture
            return true
    model.texture = original_texture
    return false