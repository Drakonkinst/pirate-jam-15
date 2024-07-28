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
	var obstacle = enemy.target_tile.obstacle
	# TODO: What if object turns into oil / can no longer be targeted?
	if not obstacle:
		enemy.target_tile = null
		transitioned.emit(self,"EnemyWalkState")
		return

	if timer >= cooldown:
		timer = 0
		enemy.attack(enemy.target_tile)
	else:
		timer += _delta
