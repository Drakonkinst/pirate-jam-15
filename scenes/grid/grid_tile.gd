extends Node2D

class_name GridTile

const BORDER = 5
@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D

var row: int
var col: int

func scale_sprite(tile_width: float, tile_height: float) -> void:
    var texture_width = sprite.texture.get_width()
    var texture_height = sprite.texture.get_height()
    sprite.scale.x = (tile_width - BORDER) / texture_width
    sprite.scale.y = (tile_height - BORDER) / texture_height

func initialize(origin: Vector2, rowIndex: int, colIndex: int, tile_width: float, tile_height: float) -> void:
    row = rowIndex
    col = colIndex
    position = origin + Vector2(col * tile_width, row * tile_height)
    collision_shape.shape.extents = Vector2(tile_width, tile_height)
    scale_sprite(tile_width, tile_height)
