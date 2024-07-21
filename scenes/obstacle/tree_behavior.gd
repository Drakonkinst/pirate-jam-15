extends ObstacleBehavior

class_name TreeBehavior

const GROWTH_TIME: float = 3

@export var fruit_tree_model: Sprite2D
@export var original_tree_model: Sprite2D
@export var harvest_area: Area2D
@export_flags_2d_physics var tree_harvest_mask

var time_until_next_fruit: float = GROWTH_TIME
var has_fruit: bool = false

func update(obstacle: Obstacle, delta: float) -> void:
    if obstacle.transmuted_state != Obstacle.TransmutedState.DEFAULT:
        if has_fruit:
            harvest_fruit()
        return

    if obstacle.burning_state.is_burned:
        fruit_tree_model.material = original_tree_model.material

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

func _on_mouse_over_area_moused_over() -> void:
    if has_fruit:
        harvest_fruit()
