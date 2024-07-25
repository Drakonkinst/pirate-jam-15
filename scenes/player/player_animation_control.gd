extends Node2D

class_name PlayerAnimationControl

const THROW_ANIMATION = "throw"
const IDLE_ANIMATION = "still"
const WALK_ANIMATION = "walk"

@onready var model: AnimatedSprite2D = $Model
var doing_action: bool = false

func _ready() -> void:
    model.animation = IDLE_ANIMATION
    model.play()

func update_animations(velocity: Vector2) -> void:
    if not doing_action:
        if velocity.is_zero_approx():
            model.animation = IDLE_ANIMATION
        else:
            model.animation = WALK_ANIMATION

func do_throw() -> void:
    model.animation = THROW_ANIMATION
    model.play()
    doing_action = true

func _on_model_animation_finished() -> void:
    print("CALLED ", model.animation)
    doing_action = false
    model.animation = IDLE_ANIMATION
    model.play()
