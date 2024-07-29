extends Node2D

class_name EnemySpawner

@export var rock_sprite: PackedScene
@export var fire_sprite: PackedScene
@export var wind_sprite: PackedScene
@export var tree_sprite: PackedScene

@export var rock_golem: PackedScene
@export var fire_golem: PackedScene
@export var wind_golem: PackedScene
@export var tree_golem: PackedScene

@onready var enemy_spawns = %EnemySpawns
@onready var ally_spawns = %AllySpawns
@export var spawning_schedule: SpawningSchedule
@export var endless_mode: bool
@export var spawn_max_offset: float = 20.0

@onready var num_spawns = len(spawning_schedule.spawns)

enum EnemyType {
    # Sprites
    RockSprite,
    TreeSprite,
    WindSprite,
    FireSprite,
    # Golems
    RockGolem,
    TreeGolem,
    WindGolem,
    FireGolem,
}

var game_timer = 0.0

var current_spawn_idx = 0
var next_spawn_time: float = INF
var next_spawn_scene: PackedScene
var next_spawn_row: int

var get_next_spawn_data: Callable = get_spawn_data

func _ready():
    if endless_mode:
        get_next_spawn_data = Callable(self,"endless_get_spawn_data")
        print("Endless Mode")
    else:
        get_next_spawn_data = Callable(self,"get_spawn_data")
        print("Normal Mode")
    get_next_spawn_data.call()

func _process(delta):
    game_timer += delta
    var spawned = check_spawn()
    if spawned and (current_spawn_idx < num_spawns or endless_mode): 
        get_next_spawn_data.call()

func check_spawn() -> bool:
    if game_timer >= next_spawn_time and current_spawn_idx < num_spawns:
        spawn_enemy_scene(next_spawn_row, next_spawn_scene)
        return true
    return false

func spawn_enemy(row: int, enemy: EnemySpawner.EnemyType) -> Enemy:
    return spawn_enemy_scene(row, spawn_type_to_scene(enemy))

func spawn_ally(row: int, enemy: EnemySpawner.EnemyType) -> Enemy:
    return spawn_ally_scene(row, spawn_type_to_scene(enemy))

func spawn_enemy_scene(row: int, enemy_scene: PackedScene) -> Enemy:
    var enemy_obj = enemy_scene.instantiate()
    enemy_obj.position = get_enemy_spawn_position(row)
    enemy_obj.row = row
    add_child(enemy_obj)
    var enemy = enemy_obj as Enemy
    current_spawn_idx += 1
    return enemy

func spawn_ally_scene(row: int, enemy_scene: PackedScene) -> Enemy:
    var enemy_obj = enemy_scene.instantiate()
    enemy_obj.position = get_ally_spawn_position(row)
    enemy_obj.row = row
    var ally = enemy_obj as Enemy
    add_child(enemy_obj)
    ally.set_ally()
    return ally

func get_enemy_spawn_position(row: int):
    var spawn = enemy_spawns.get_child(row)
    # print(spawn.name)
    var spawn_pos = spawn.global_position
    spawn_pos += Vector2(0, randf_range(-spawn_max_offset, spawn_max_offset))
    return spawn_pos

func get_ally_spawn_position(row: int):
    var spawn = ally_spawns.get_child(row)
    # print(spawn.name)
    var spawn_pos = spawn.global_position
    spawn_pos += Vector2(0, randf_range(-spawn_max_offset, spawn_max_offset))
    return spawn_pos

func get_spawn_data():
    var next_spawn = spawning_schedule.spawns[current_spawn_idx]
    next_spawn_time = next_spawn.spawn_time
    next_spawn_scene = spawn_type_to_scene(next_spawn.spawn_type)
    next_spawn_row = next_spawn.row
    if next_spawn_row == SpawnData.RowPosition.Random:
        next_spawn_row = randi_range(0,4)

# Alternative Endless Strategy
func endless_get_spawn_data():
    next_spawn_scene = spawn_type_to_scene(randi_range(0,EnemyType.values()[randi() % EnemyType.size()]))
    next_spawn_time = game_timer + 1 + (randi() % 2)
    next_spawn_row = randi_range(0,4)

func get_enemies_in_tile(tile: GridTile) -> Array[Enemy]:
    var result: Array[Enemy] = []
    var grid = GlobalVariables.get_grid()
    for node in get_children():
        if node is Enemy and grid.screenspace_to_tile(node.global_position) == tile:
            result.append(node as Enemy)
    return result

func spawn_type_to_scene(spawn_type: EnemySpawner.EnemyType):
    var enemy_scene: PackedScene
    match spawn_type:
        #Sprite
        EnemyType.RockSprite:
            enemy_scene = rock_sprite
        EnemyType.FireSprite:
            enemy_scene = fire_sprite
        EnemyType.WindSprite:
            enemy_scene = wind_sprite
        EnemyType.TreeSprite:
            enemy_scene = tree_sprite
        #Golem
        EnemyType.RockGolem:
            enemy_scene = rock_golem
        EnemyType.FireGolem:
            enemy_scene = fire_golem
        EnemyType.WindGolem:
            enemy_scene = wind_golem
        EnemyType.TreeGolem:
            enemy_scene = tree_golem
        #Default to regular sprite
        _:
            enemy_scene = rock_sprite
    return enemy_scene


