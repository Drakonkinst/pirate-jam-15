extends ObstacleBehavior

class_name TreeBehavior

const GROWTH_MIN_TIME: float = 15
const GROWTH_MAX_TIME: float = 30
const MAX_FRUIT := 4

@export var fruit_tree_model: Sprite2D
@export var original_tree_model: Sprite2D
@export var harvest_area: Area2D
@export var fruit_harvest_points: Array[FruitHarvestPoint]
@export_flags_2d_physics var tree_harvest_mask

var time_until_next_fruit: float = randf_range(GROWTH_MIN_TIME, GROWTH_MAX_TIME)
var num_fruit: int = 0

func _ready() -> void:
    for harvest_point in fruit_harvest_points:
        harvest_point.hide_fruit()

func update(obstacle: Obstacle, delta: float) -> void:
    if obstacle.transmuted_state != Obstacle.TransmutedState.DEFAULT:
        if num_fruit > 0:
            harvest_fruit()
        return

    if obstacle.burning_state.is_burned:
        fruit_tree_model.material = original_tree_model.material

    if num_fruit < MAX_FRUIT and time_until_next_fruit > 0:
        time_until_next_fruit -= delta
    if time_until_next_fruit <= 0:
        grow_fruit()
        time_until_next_fruit = randf_range(GROWTH_MIN_TIME, GROWTH_MAX_TIME)

func grow_fruit() -> void:
    var num_open_slots = MAX_FRUIT - num_fruit
    num_fruit += 1
    for harvest_point in fruit_harvest_points:
        if harvest_point.has_fruit:
            continue
        elif num_open_slots <= 0:
            print("ERROR: Failed to find an open slot")
            return
        elif randf() < 1.0 / num_open_slots:
            harvest_point.grow_fruit()
            return
        else:
            num_open_slots -= 1

func harvest_fruit() -> void:
    for harvest_point in fruit_harvest_points:
        if harvest_point.has_fruit:
            GlobalVariables.get_pickup_manager().spawn_pickup_drop(Pickup.PickupType.FRUIT, harvest_point.global_position)
            harvest_point.hide_fruit()
    num_fruit = 0

func _on_mouse_over_area_moused_over() -> void:
    if num_fruit:
        harvest_fruit()

func _on_tree_removed() -> void:
    harvest_fruit()
