extends Node2D


@export var move_speed = 150.0
@export var row = 0 

enum EnemyState {
    MOVING,
    ATTACKING,
}

var state = EnemyState.MOVING

var moving: bool = true
var obstacle: Obstacle = null

@onready var sprite = %Sprite

func _ready():
    pass

func _process(delta):
    var adjacent_tile = get_left_tile()
    if adjacent_tile and adjacent_tile.obstacle != null:
        obstacle = adjacent_tile.obstacle
        state = EnemyState.ATTACKING
    else:
        state = EnemyState.MOVING

    match state:
        EnemyState.MOVING:
            walk(delta)
        EnemyState.ATTACKING:
            attack(obstacle)

func get_left_tile() -> GridTile:
    var size_x = sprite.texture.get_width() * sprite.scale.x
    var detection_offset = Vector2(-size_x, 0)
    var shadow_left_position: Vector2 = global_position + detection_offset

    var tile: GridTile = GlobalVariables.get_grid().screenspace_to_tile(shadow_left_position)
    return tile

func attack(target_obstacle: Obstacle):
    # TODO: Implement small timer
    if target_obstacle != null:
        target_obstacle.damage(1)

func walk(delta):
    global_position += Vector2(-move_speed * delta,0)

