extends Node2D

class_name ObstacleModel

@onready var model: Sprite2D = $Base
@onready var flaming_overlay: Node2D = $Flaming

@export var burnt_material: Material
@export var transmutable_map: Array[TransmutableEntry]
@export var random_offset: Vector2

var original_texture: Texture
var original_position: Vector2
var offset: Vector2 = Vector2.ZERO

func _ready() -> void:
    original_texture = model.texture
    original_position = position
    if random_offset != Vector2.ZERO:
        var offset_x = randf_range(-random_offset.x, random_offset.x)
        var offset_y = randf_range(-random_offset.y, random_offset.y)
        set_offset(Vector2(offset_x, offset_y))

func set_offset(value: Vector2):
    offset = value
    position = original_position + offset

func set_flaming(is_on_fire: bool) -> void:
    if is_on_fire:
        flaming_overlay.show()
    else:
        flaming_overlay.hide()

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