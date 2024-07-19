extends Node2D

# Uses inherited scenes to keep child components constant for all types of obstacles
class_name Obstacle

# Some objects can be tramsuted which should overlay their shape with a texture
enum TransmutedMaterial {
    DEFAULT, WOOD, STONE, QUARTZ
}

# TODO: Reference a "Stats" resource for starting health, resource drops, whether it can be moved through, and whether it is transmutable

var tile: GridTile
var transmuted: TransmutedMaterial = TransmutedMaterial.DEFAULT
@onready var health: Health = $Health

func set_tile(obj: GridTile) -> void:
    tile = obj

func damage(value: int) -> void:
    # TODO: Send damage to health object
    pass

func _ready() -> void:
    pass


