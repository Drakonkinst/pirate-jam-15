extends Node2D

# Point and click thrown projectile
# When creating, need to specify the direction + speed necessary to reach target
# As well as the y position of its target so it knows when to stop
class_name ThrownProjectile

const GRAVITY: float = 10.0

@onready var sprite: Sprite2D = $Sprite2D

@export var dir: Vector2 = Vector2(0.5, -0.5)
@export var speed: float = 10.0
@export var rotation_speed_degrees: float = 180.0

var velocity: Vector2 = Vector2.ZERO
var target_y: float = 500

func _ready() -> void:
    # direction and magnitude!
    velocity = dir * speed

func _physics_process(delta: float) -> void:
    velocity.y += GRAVITY * delta
    position += velocity
    rotation += deg_to_rad(rotation_speed_degrees * delta)

    if position.y >= target_y:
        # TODO: Has hit its target
        queue_free()