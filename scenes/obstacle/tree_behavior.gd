extends ObstacleBehavior

class_name TreeBehavior

const GROWTH_TIME: float = 3

@export var fruit_tree_model: Sprite2D
@export var original_tree_model: Sprite2D
@export var harvest_area: Area2D
@export_flags_2d_physics var tree_harvest_mask

var time_until_next_fruit: float = GROWTH_TIME
var has_fruit

func update(obstacle: Obstacle, delta: float) -> void:
    if obstacle.transmuted_state != Obstacle.TransmutedState.DEFAULT:
        return

    if not has_fruit and time_until_next_fruit > 0:
        time_until_next_fruit -= delta
    if time_until_next_fruit <= 0:
        grow_fruit()
        time_until_next_fruit = GROWTH_TIME

func grow_fruit() -> void:
    has_fruit = true
    fruit_tree_model.show()
    original_tree_model.hide()

func harvest_fruit() -> void:
    # TODO: Fruit harvesting logic
    has_fruit = false
    fruit_tree_model.hide()
    original_tree_model.show()

# https://forum.godotengine.org/t/is-it-possible-to-detect-if-a-mouse-pointer-is-hovering-over-area-2d/15073
# TODO: This runs for all trees, might be better to run this once and grab the tree obstacle from there
# mouse_entered doesn't work consistently so I think this way is better
func _physics_process(_delta: float) -> void:
    var space = get_world_2d().direct_space_state
    var mouse_pos = get_viewport().get_mouse_position()
    var parameters: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
    parameters.position = mouse_pos
    parameters.collide_with_areas = true
    parameters.collide_with_bodies = false
    parameters.collision_mask = tree_harvest_mask
    var hit: Array[Dictionary] = space.intersect_point(parameters, 1)
    # TODO: Is there a better way than checking the reference? An ID, maybe?
    if hit && hit[0].collider == harvest_area:
        harvest_fruit()