extends State

class_name EnemyWalkState

const OIL_SLOW_FACTOR = 0.75
const LIGHT_SLOW_FACTOR = 0.5

@export var enemy: Enemy

var speed_multiplier = 1.0

func enter():
	# Change to walking animation
	enemy.sprite.frame = 0
	enemy.sprite.play()

func exit():
	# End current Animation
	enemy.sprite.frame = 0
	enemy.sprite.pause()
	enemy.velocity = Vector2.ZERO

func update(_delta):
	var current_tile: GridTile = enemy.get_current_tile()
	var adjacent_tile: GridTile = enemy.get_tile_ahead()
	if current_tile and current_tile.has_valid_obstacle_target():
		call_deferred("start_attack", current_tile)
	elif adjacent_tile and adjacent_tile.has_valid_obstacle_target():
		call_deferred("start_attack", adjacent_tile)

	speed_multiplier = 1.0
	if current_tile and current_tile.obstacle and current_tile.obstacle.data.id == Obstacle.Type.OIL_SPILL:
		speed_multiplier *= OIL_SLOW_FACTOR
	if GlobalVariables.get_light_manager().is_in_light(enemy.global_position):
		speed_multiplier *= LIGHT_SLOW_FACTOR

func physics_update(delta):
	var direction: Vector2 = Vector2.LEFT
	if enemy.is_ally:
		direction = Vector2.RIGHT

	enemy.velocity = direction * enemy.enemy_data.move_speed * delta * speed_multiplier

func start_attack(adjacent_tile: GridTile):
	enemy.target_tile = adjacent_tile
	transitioned.emit(self,"EnemyAttackState")
