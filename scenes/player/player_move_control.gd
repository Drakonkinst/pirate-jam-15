extends Node2D

# CharacterBody2D is probably overkill for this, could've just coded it custom
# Ah well, it works

class_name PlayerMoveControl

@export var speed: float = 400

# Set during initialization
var min_position: float = -INF
var max_position: float = -INF

func initialize() -> void:
    var extents: Vector2 = GlobalVariables.get_grid().get_y_extents()
    min_position = extents.x
    max_position = extents.y

func update(character: CharacterBody2D) -> void:
    character.velocity = _get_velocity_from_input()
    character.move_and_slide()
    character.position.y = clamp(character.position.y, min_position, max_position)

func _get_velocity_from_input() -> Vector2:
    var velocity_dir := Input.get_vector("move_up", "move_down", "move_up", "move_down")
    if velocity_dir.is_zero_approx():
        return Vector2.ZERO
    velocity_dir.x = 0
    return velocity_dir * speed

