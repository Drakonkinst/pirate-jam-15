extends State

class_name EnemyWalkState

@export var enemy: Enemy
@onready var animPlayer: AnimationPlayer = enemy.get_node("AnimationPlayer")

@export var slow_ratio: float = 0.5
var speed_multiplier = 1.0

func enter():
	# Change to walking animation
	animPlayer.play("walk")

func exit():
	# End current Animation
	animPlayer.stop()
	enemy.velocity = Vector2.ZERO

func update(_delta):
	var adjacent_tile = enemy.get_left_tile()
	var current_tile = enemy.get_current_tile()
	if adjacent_tile and adjacent_tile.obstacle != null and !adjacent_tile.obstacle.data.can_pass_through:
		call_deferred("start_attack", adjacent_tile)
	if current_tile and current_tile.obstacle != null and current_tile.obstacle.data.can_pass_through:
		speed_multiplier = slow_ratio
	else:
		speed_multiplier = 1.0

func physics_update(delta):
	enemy.velocity = Vector2.LEFT * enemy.move_speed * delta * speed_multiplier

func start_attack(adjacent_tile: GridTile):
	enemy.target_tile = adjacent_tile
	transitioned.emit(self,"EnemyAttackState")
