extends CharacterBody2D

class_name Enemy

const DEFAULT_ANIMATION = "default"
const ENEMY_FIRE_DAMAGE := 20
const ENEMY_STEP_ON_FIRE_TIME := 1.0
const ENEMY_OBSTACLE_FIRE_TIME := 2.0

@export var row = 0
@export var enemy_data: EnemyData
@export var attack_audio: AudioRandomizer

var moving: bool = true
var target_tile: GridTile = null
var is_ally: bool = false

@export var state_machine: StateMachine
@export var ally_color_tint: Color
@onready var sprite: AnimatedSprite2D = %Sprite
@onready var health: Health = %Health
@onready var burning_state: BurningState = %BurningState
@onready var flaming_overlay: Node2D = %Flaming
@onready var light_anchor: Node2D = %LightAnchor
@onready var damage_audio: AudioRandomizer = %DamageAudio
var size_x: float
var light_circle: LightCircle
var loot: Dictionary
var has_reached_end: bool = false

func _ready():
    health.set_max_health(enemy_data.health)
    health.set_health(enemy_data.health)
    sprite.play(DEFAULT_ANIMATION)
    sprite.pause()
    size_x = sprite.sprite_frames.get_frame_texture(DEFAULT_ANIMATION, 0).get_width() * sprite.scale.x
    state_machine.init()
    loot = enemy_data.loot.resolve()

func _process(_delta: float) -> void:
    var grid: Grid = GlobalVariables.get_grid()
    var tile: GridTile = grid.screenspace_to_tile(global_position)
    if tile == null:
        if not is_ally and has_reached_end:
            GlobalVariables.curr_game.damage_player(enemy_data.attack_damage)
            queue_free()
            pass
        return
    var obstacle: Obstacle = tile.obstacle
    if obstacle and obstacle.burning_state.is_burning():
        set_on_fire(ENEMY_STEP_ON_FIRE_TIME)
    if is_ally:
        if grid.should_ally_stop(tile):
            has_reached_end = true
    else:
        if grid.should_enemy_stop(tile):
            has_reached_end = true

func _physics_process(_delta):
    move_and_slide()

func get_tile_ahead() -> GridTile:
    var detection_offset = -size_x / 4.0
    if is_ally:
        detection_offset *= -1
    var tile: GridTile = GlobalVariables.get_grid().screenspace_to_tile(global_position + Vector2(detection_offset, 0.0))
    return tile

func set_ally() -> void:
    is_ally = true
    sprite.flip_h = true
    sprite.self_modulate = ally_color_tint

func get_current_tile() -> GridTile:
    var tile: GridTile = GlobalVariables.get_grid().screenspace_to_tile(global_position)
    return tile

func attack(tile: GridTile) -> bool:
    if tile == null or tile.obstacle == null:
        return false
    if enemy_data.type == EnemySpawner.EnemyType.FireSprite:
        tile.obstacle.set_on_fire(ENEMY_OBSTACLE_FIRE_TIME)
    tile.obstacle.damage(enemy_data.attack_damage)
    attack_audio.play_random()
    return true

func damage(val, is_magic_bolt: bool = false):
    if is_magic_bolt:
        damage_audio.play_random()
    health.damage(val)
    if is_magic_bolt:
        if health.health <= 0:
            GlobalVariables.get_projectile_manager().play_death_audio()

func _create_pickup_drops():
    for item: Pickup.PickupType in loot.keys():
        var count: int = loot[item]
        GlobalVariables.get_pickup_manager().spawn_pickup_drop(item, global_position, count)

func _on_health_death():
    _create_pickup_drops()
    if enemy_data.type == EnemySpawner.EnemyType.TreeGolem:
        _place_obstacle_nearby(Obstacle.Type.SAPLING)
    elif enemy_data.type == EnemySpawner.EnemyType.RockGolem:
        _place_obstacle_nearby(Obstacle.Type.ROCK)

    if not is_ally and not has_reached_end:
        if enemy_data.type == EnemySpawner.EnemyType.TreeGolem or enemy_data.type == EnemySpawner.EnemyType.RockGolem:
            GlobalVariables.curr_game.golems_killed += 1
            GlobalVariables.curr_game.score += 1000
        else:
            GlobalVariables.curr_game.golems_killed += 1
            GlobalVariables.curr_game.score += 100
    queue_free()

func _place_obstacle_nearby(obstacle: Obstacle.Type) -> bool:
    var grid: Grid = GlobalVariables.get_grid()
    var tile: GridTile = grid.screenspace_to_tile(global_position)
    # First try to place on same tile
    if _place_obstacle_on([tile], obstacle):
        return true
    # Then cardinal neighbors
    if _place_obstacle_on(grid.get_neighbors(tile, false, false), obstacle):
        return true
    # Then diagonal
    if _place_obstacle_on(grid.get_neighbors(tile, true, false), obstacle):
        return true
    return false

func _place_obstacle_on(options: Array[GridTile], obstacle) -> bool:
    for tile: GridTile in options:
        if tile.obstacle and not tile.obstacle.data.replaceable:
            continue
        GlobalVariables.get_obstacle_manager().spawn_obstacle(obstacle, tile, true)
        return true
    return false

func has_light() -> bool:
    return light_circle != null and is_instance_valid(light_circle)

# Must always be preceded by a has_light() check
func delete_light() -> void:
    light_circle.queue_free()
    light_circle = null

func is_flammable() -> bool:
    return enemy_data.flammable

func set_on_fire(duration: float) -> void:
    if not is_flammable():
        return
    burning_state.start_burning_time(duration)
    flaming_overlay.show()

    # Spawn light
    if has_light():
        return
    light_circle = GlobalVariables.get_light_manager().spawn_tracking(light_anchor, GlobalVariables.FLAMING_ENEMY_LIGHT_RADIUS, LightManager.Type.FIRE)

func put_out_fire() -> void:
    burning_state.reset_burning_time()
    flaming_overlay.hide()
    if has_light():
        delete_light()

func _on_burning_state_burnt() -> void:
    # Do nothing
    pass

func _on_burning_state_fire_expired() -> void:
    put_out_fire()

func _on_burning_state_fire_tick() -> void:
    var dmg = ENEMY_FIRE_DAMAGE
    if enemy_data.type == EnemySpawner.EnemyType.TreeGolem:
        dmg *= 4
    if enemy_data.type == EnemySpawner.EnemyType.TreeSprite:
        dmg *= 2
    damage(dmg)
