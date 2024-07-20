extends Node2D


@export var move_speed = 50.0
@export var row = 0 
@export var sprite_scale: float = 1



enum enemy_states {
    MOVING,
    ATTACKING,
}

var state = enemy_states.MOVING

var moving = true
var obstacle = null

@onready var sprite = %Sprite

func _ready():
    sprite.scale = Vector2(sprite_scale,sprite_scale)

func _process(delta):
    var adjacent_tile = get_left_tile()
    if adjacent_tile and adjacent_tile.obstacle != null:
        obstacle = adjacent_tile.obstacle
        state = enemy_states.ATTACKING
    else:
        state = enemy_states.MOVING

    match state:
        enemy_states.MOVING:
            walk(delta)
        enemy_states.ATTACKING:
            attack(obstacle)

func get_left_tile():
    var size_x = sprite.texture.get_width() * sprite.scale.x
    var detection_offset = Vector2(-size_x,0)
    var shadow_left_position: Vector2 = global_position + detection_offset

    var tile = GlobalVariables.curr_game.grid.screenspace_to_tile(shadow_left_position)
    return tile

func attack(target_obstacle):
    # Implement small timer
    if target_obstacle != null and target_obstacle.has_method("damage"):
        target_obstacle.damage(1)

func walk(delta):
    global_position += Vector2(-move_speed * delta,0)

