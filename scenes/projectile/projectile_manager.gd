extends Node2D

class_name ProjectileManager

const FIRE_INPUT := "fire"
const GRAVITY: float = 1000.0
const INVERT_Y: Vector2 = Vector2(1.0, -1.0)

@onready var player: Player = get_tree().get_nodes_in_group(GlobalVariables.PLAYER_GROUP)[0]

@export var projectile_scene: PackedScene
@export var debug_marker_scene: PackedScene
@export var show_debug: bool = false
@export var throw_offset: Vector2
@export var arc_height_multiplier: float = 0.25

func fire_projectile(from: Vector2, to: Vector2) -> void:
    var projectile_obj = projectile_scene.instantiate()
    add_child(projectile_obj)
    var projectile = projectile_obj as ThrownProjectile
    projectile.global_position = from
    projectile.target_y = to.y
    projectile.gravity = GRAVITY
    projectile.velocity = calculate_trajectory(from, to)

func place_debug_circle(pos: Vector2):
    if not show_debug:
        return
    var obj = debug_marker_scene.instantiate()
    add_child(obj)
    obj.position = pos

# https://gamedev.stackexchange.com/questions/114635
func calculate_trajectory(from: Vector2, to: Vector2) -> Vector2:
    # Act as if starting from the origin
    var end = (to - from)
    # Flip y since +y is down
    end.y = -end.y
    place_debug_circle(end * INVERT_Y + from)

    # Select a point above the player to make a nice arc
    var midpoint: Vector2 = Vector2(end.x / 2, max(end.y, arc_height_multiplier * end.x))
    place_debug_circle(midpoint * INVERT_Y + from)

    # Find time to reach end in a parabola that passes through all three points
    var time_to_reach_target = sqrt(2 * (end.y - midpoint.y * end.x / midpoint.x) / (-GRAVITY * (1 - midpoint.x/end.x)))

    # Find velocity required to reach end in that time
    var velocity = end / time_to_reach_target - time_to_reach_target * Vector2(0, -GRAVITY / 2)

    # Flip y since +y is pointing down
    velocity.y = -velocity.y
    return velocity

# TODO: Create lockout zones so the potion cannot be thrown towards weird positions
func _input(event) -> void:
    if event.is_action_pressed(FIRE_INPUT):
        var mouse_pos = get_global_mouse_position()
        fire_projectile(player.global_position + throw_offset, mouse_pos)

