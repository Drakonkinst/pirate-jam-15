extends Node2D

# Point and click thrown projectile
# When creating, need to specify the direction + speed necessary to reach target
# As well as the y position of its target so it knows when to stop
class_name ThrownProjectile

enum Type {
    TORCH, POTION_OIL, POTION_WOOD, POTION_STONE, POTION_QUARTZ
}

@onready var sprite: Sprite2D = $Sprite2D

@export var rotation_speed_degrees: float = 180.0
@export var behavior: ProjectileBehavior

var velocity: Vector2 = Vector2.ZERO
var target_y: float = 500
var gravity: float # Set by ProjectileManager

func _physics_process(delta: float) -> void:
    velocity.y += gravity * delta
    position += velocity * delta
    rotation += deg_to_rad(rotation_speed_degrees * delta)

    # Check if it has reached its target y position on its downward arc
    # Then it has reached its target
    if position.y >= target_y && velocity.y > 0:
        if behavior:
            behavior.on_land(Vector2(position.x, target_y))
        queue_free()
