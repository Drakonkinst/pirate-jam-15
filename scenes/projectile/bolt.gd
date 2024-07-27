extends Node2D

class_name MagicBolt

@export var direction: Vector2
@export var speed: float = 800.0
# TODO: Spirits should die in 1-2 shots, so balance health and damage values accordingly
@export var bolt_damage: float = 75.0

func init(from: Vector2, to: Vector2):
	global_position = from
	direction = (to - from).normalized()
	look_at(to)

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.damage(bolt_damage)
		queue_free()
