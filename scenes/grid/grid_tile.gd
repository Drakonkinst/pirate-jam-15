extends Node2D

class_name GridTile

const BORDER = 5

@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@onready var player: Player = get_tree().get_nodes_in_group(GlobalVariables.PLAYER_GROUP)[0]
@onready var obstacle_parent: Node2D = $ObstacleParent

var row: int
var col: int
var obstacle: Obstacle = null
var default_opacity: float
var default_color: Color

func _ready() -> void:
    default_color = sprite.modulate

func _physics_process(_delta: float) -> void:
    if _should_highlight():
        sprite.modulate = Color.WHITE
        sprite.modulate.a = 0.25
    else:
        sprite.modulate = default_color

    # if grid.screenspace_to_tile(mouse_pos) == self:
    #     sprite.modulate.a = 1
    # elif grid.is_tile_in_radius(self, mouse_pos, GlobalVariables.POTION_RADIUS):
    #     sprite.modulate.a = 0.75
    # else:
    #     sprite.modulate.a = default_opacity

func _should_highlight() -> bool:
    var grid = GlobalVariables.get_grid()
    var mouse_pos = get_global_mouse_position()
    var current_tool: ToolBar.Tool = GlobalVariables.get_toolbar().current_tool
    if current_tool == ToolBar.Tool.PICKAXE:
        return grid.screenspace_to_tile(mouse_pos) == self
    if current_tool == ToolBar.Tool.SUMMON:
        var player_row = grid.get_grid_row_at_pos(player.global_position)
        return col == 0 && row == player_row
    return false

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

func has_valid_obstacle_target() -> bool:
    return obstacle != null and not obstacle.data.can_pass_through

func scale_sprite(tile_width: float, tile_height: float) -> void:
    var texture_width = sprite.texture.get_width()
    var texture_height = sprite.texture.get_height()
    sprite.scale.x = (tile_width - BORDER) / texture_width
    sprite.scale.y = (tile_height - BORDER) / texture_height

func initialize(origin: Vector2, rowIndex: int, colIndex: int, tile_width: float, tile_height: float) -> void:
    row = rowIndex
    col = colIndex
    position = origin + Vector2(col * tile_width, row * tile_height) + Vector2(tile_width / 2.0, tile_height / 2.0)
    collision_shape.shape.extents = Vector2(tile_width, tile_height)
    scale_sprite(tile_width, tile_height)

func _on_obstacle_removed() -> void:
    clear_obstacle()
