extends State

class_name EnemyAttackState

const ATTACK_FLAMING_TIME = 3.0

@export var enemy: Enemy

@onready var cooldown = enemy.enemy_data.attack_frequency
@onready var timer: float = 0.0

func enter():
    timer = 0

func exit():
    timer = 0

func update(delta: float):
    if not enemy.target_tile.has_valid_obstacle_target():
        enemy.target_tile = null
        transitioned.emit(self, "EnemyWalkState")
        return

    if enemy.is_ally:
        return

    if timer >= cooldown:
        timer = 0
        enemy.attack(enemy.target_tile)
        var obstacle: Obstacle = enemy.target_tile.obstacle
        if obstacle and obstacle.burning_state.is_burning():
            enemy.set_on_fire(ATTACK_FLAMING_TIME)
    else:
        timer += delta
