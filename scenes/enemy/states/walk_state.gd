extends State

class_name EnemyWalkState

@export var enemy: ShadowEnemy


func enter():
    # Change to walking animation
    pass

func exit():
    # End current Animation
    enemy.velocity = Vector2.ZERO

func update(_delta):
    var adjacent_tile = enemy.get_left_tile()
    if adjacent_tile and adjacent_tile.obstacle != null and !adjacent_tile.obstacle.data.can_pass_through:
        call_deferred("start_attack",adjacent_tile.obstacle)

func physics_update(delta):
    enemy.velocity = Vector2.LEFT * enemy.move_speed * delta
    print("Walkin")

func start_attack(adjacent_obstacle):
    enemy.obstacle = adjacent_obstacle
    transitioned.emit(self,"EnemyAttackState")