extends Node2D

class_name MagicBolt

@export var direction: Vector2
@export var speed: float = 800.0
@export var bolt_damage: float = 25.0

func init(from: Vector2, to: Vector2):
    global_position = from
    direction = (to - from).normalized()
    look_at(to)

func _process(delta: float) -> void:
    position += direction * speed * delta

func _on_hitbox_body_entered(body: Node2D) -> void:
    print(body.name)
    body.damage(bolt_damage)
