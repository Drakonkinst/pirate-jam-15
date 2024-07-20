extends Node2D

class_name GridTile

const BORDER = 5

@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D

@onready var obstacle_parent: Node2D = $ObstacleParent

var row: int
var col: int
var obstacle: Obstacle = null

func clear_obstacle() -> void:
    # Remove all children
    for node in obstacle_parent.get_children():
        obstacle_parent.remove_child(node)
        node.queue_free()
    obstacle = null

func set_obstacle(obj: Obstacle) -> void:
    if obstacle:
        clear_obstacle()
    obstacle = obj
    obstacle_parent.add_child(obstacle)
    obstacle.set_tile(self)
    obstacle.removed.connect(_on_obstacle_removed)

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

func _on_obstacle_removed() -> void:
    clear_obstacle()
