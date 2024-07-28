extends State

class_name EnemyAttackState

@export var enemy: Enemy

@onready var cooldown = enemy.enemy_data.attack_frequency

@onready var timer = 0

func enter():
	timer = 0

func exit():
	timer = 0

func update(_delta):
	if not enemy.target_tile.has_valid_obstacle_target():
		enemy.target_tile = null
		transitioned.emit(self, "EnemyWalkState")
		return

	if enemy.is_ally:
		return

	if timer >= cooldown:
		timer = 0
		enemy.attack(enemy.target_tile)
	else:
		timer += _delta
