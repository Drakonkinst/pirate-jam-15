extends Node2D

class_name Obstacle

enum TransmutedMaterial {
    DEFAULT, WOOD, STONE, QUARTZ
}

# TODO: Reference a "Stats" resource for starting health, and whether it is transmutable

var tile: GridTile
@onready var health: Health = $Health

func set_tile(obj: GridTile) -> void:
    tile = obj

func damage(value: int) -> void:
    # TODO: Send damage to health object
    pass

func _ready() -> void:
    pass


