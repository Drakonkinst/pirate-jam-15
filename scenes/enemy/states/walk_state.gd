extends State

class_name EnemyWalkState

const OIL_SLOW_FACTOR = 0.75
const LIGHT_SLOW_FACTOR = 0.5

const SCAN_INTERVAL = 1.0

@export var enemy: Enemy

var speed_multiplier = 1.0
var curr_opponent: Enemy = null
var time_until_next_scan: float = 0.0
var stopped_moving = false
var attack_timer: float = 0.0

func enter():
    # Change to walking animation
    enemy.sprite.frame = 0
    enemy.sprite.play()
    stopped_moving = false

func exit():
    # End current Animation
    enemy.sprite.frame = 0
    enemy.sprite.pause()
    stopped_moving = true
    enemy.velocity = Vector2.ZERO

func update(delta):
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

    # Stop moving at end if ally is at end of grid
    if enemy.is_ally and enemy.has_reached_end:
        speed_multiplier *= 0
        enemy.sprite.pause()
        stopped_moving = false

    if curr_opponent != null:
        speed_multiplier = 0
        if not stopped_moving:
            enemy.sprite.pause()
            stopped_moving = true
        attack_timer += delta
        if attack_timer >= enemy.enemy_data.attack_frequency:
            curr_opponent.damage(enemy.enemy_data.attack_damage)
            attack_timer = 0
    elif stopped_moving:
        enemy.sprite.play()
        stopped_moving = false

    time_until_next_scan -= delta
    if time_until_next_scan <= 0:
        curr_opponent = search_for_opponents()

func search_for_opponents() -> Enemy:
    var enemy_spawner: EnemySpawner = GlobalVariables.get_enemy_spawner()
    var enemies: Array[Enemy]
    if enemy.is_ally:
        enemies = enemy_spawner.get_enemies_in_row(enemy.row)
    else:
        enemies = enemy_spawner.get_allies_in_row(enemy.row)

    var origin_x: float = enemy.global_position.x
    var min_x: float = origin_x
    var closest_opponent: Enemy = null
    for opponent: Enemy in enemies:
        if opponent.row != enemy.row:
            continue
        if opponent.is_ally == enemy.is_ally:
            continue
        var opponent_x: float = opponent.global_position.x
        if opponent_x >= origin_x and opponent_x <= min_x:
            min_x = opponent_x
            closest_opponent = opponent
    return closest_opponent


func physics_update(delta):
    var direction: Vector2 = Vector2.LEFT
    if enemy.is_ally:
        direction = Vector2.RIGHT

    enemy.velocity = direction * enemy.enemy_data.move_speed * delta * speed_multiplier

func start_attack(adjacent_tile: GridTile):
    enemy.target_tile = adjacent_tile
    transitioned.emit(self, "EnemyAttackState")
