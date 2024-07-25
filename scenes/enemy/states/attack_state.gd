extends State

class_name EnemyAttackState

@export var enemy: ShadowEnemy

var cooldown = 0.25

var timer = 0


func enter():
    timer = 0
    enemy.obstacle.removed.connect(end_attack)

func exit():
    timer = 0

func update(_delta):
    if timer >= cooldown and enemy.obstacle:
        timer = 0
        enemy.attack(enemy.obstacle)
    else:
        timer += _delta


func end_attack():
    enemy.obstacle = null
    transitioned.emit(self,"EnemyWalkState")
