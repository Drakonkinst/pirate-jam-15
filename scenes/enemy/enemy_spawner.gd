extends Node2D

class_name EnemySpawner

signal wave_ended

# Connect to day_ended signal to start using next spawning_schedule
@export var day_cycle_manager: DayCycleManager

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

@export var spawning_schedules: Array[SpawningSchedule]
@onready var curr_spawning_schedule = spawning_schedules[0]
@export var endless_mode: bool
@export var spawn_max_offset: float = 20.0

@onready var enemies_folder: Node2D = %EnemiesFolder
@onready var allies_folder: Node2D = %AlliesFolder

@onready var num_spawns = 1:
	get: return len(curr_spawning_schedule.spawns)

@export var spawning = false
var round_in_progress = false

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
	if not spawning:
		if get_num_enemies() <= 0 and round_in_progress:
			wave_ended.emit()
			round_in_progress = false

		return
	
	game_timer += delta
	var spawned = check_spawn()
	if spawned:
		if current_spawn_idx >= num_spawns:
			spawning = false 
		else:
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

func summon_ally_at_tile(type: EnemySpawner.EnemyType, tile: GridTile, y_pos: float) -> Enemy:
	var x_pos = GlobalVariables.get_grid().get_min_x(tile)
	var enemy_obj = spawn_type_to_scene(type).instantiate()
	enemy_obj.position = Vector2(x_pos, y_pos)
	enemy_obj.row = tile.row
	var ally = enemy_obj as Enemy
	allies_folder.add_child(enemy_obj)
	ally.set_ally()
	return ally

func spawn_enemy_scene(row: int, enemy_scene: PackedScene) -> Enemy:
	var enemy_obj = enemy_scene.instantiate()
	enemy_obj.position = get_enemy_spawn_position(row)
	enemy_obj.row = row
	enemies_folder.add_child(enemy_obj)
	var enemy = enemy_obj as Enemy
	current_spawn_idx += 1
	return enemy

func spawn_ally_scene(row: int, enemy_scene: PackedScene) -> Enemy:
	var enemy_obj = enemy_scene.instantiate()
	enemy_obj.position = get_ally_spawn_position(row)
	enemy_obj.row = row
	var ally = enemy_obj as Enemy
	allies_folder.add_child(enemy_obj)
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
	var next_spawn = curr_spawning_schedule.spawns[current_spawn_idx]
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

func get_enemies_in_tile(tile: GridTile, is_ally: bool = false) -> Array[Enemy]:
	var result: Array[Enemy] = []
	var grid = GlobalVariables.get_grid()
	var parent: Node2D
	if is_ally:
		parent = allies_folder
	else:
		parent = enemies_folder
	for node in parent.get_children():
		if node is Enemy and grid.screenspace_to_tile(node.global_position) == tile:
			result.append(node as Enemy)
	return result

func spawn_type_to_scene(spawn_type: EnemySpawner.EnemyType):
	var enemy_scene: PackedScene
	match spawn_type:
		# Sprite
		EnemyType.RockSprite:
			enemy_scene = rock_sprite
		EnemyType.FireSprite:
			enemy_scene = fire_sprite
		EnemyType.WindSprite:
			enemy_scene = wind_sprite
		EnemyType.TreeSprite:
			enemy_scene = tree_sprite
		# Golem
		EnemyType.RockGolem:
			enemy_scene = rock_golem
		EnemyType.FireGolem:
			enemy_scene = fire_golem
		EnemyType.WindGolem:
			enemy_scene = wind_golem
		EnemyType.TreeGolem:
			enemy_scene = tree_golem
		# Default to regular sprite
		_:
			enemy_scene = rock_sprite
	return enemy_scene

func start_endless():
	endless_mode = true
	spawning = true
	get_next_spawn_data = endless_get_spawn_data
	get_next_spawn_data.call()

func start_next_spawning_schedule(curr_round: int):
	curr_spawning_schedule = spawning_schedules[curr_round]
	current_spawn_idx = 0

	get_next_spawn_data.call()
	spawning = true
	round_in_progress = true
	game_timer = 0.0

func _on_day_cycle_manager_day_ended(curr_round):
	start_next_spawning_schedule(curr_round)

func _on_day_cycle_manager_game_ended():
	start_endless()

func get_num_enemies():
	return enemies_folder.get_child_count()

func get_num_allies():
	return allies_folder.get_child_count()

func get_enemies_in_row(row: int) -> Array[Enemy]:
	return get_mobs_in_row(enemies_folder, row)

func get_allies_in_row(row: int) -> Array[Enemy]:
	return get_mobs_in_row(allies_folder, row)

func get_mobs_in_row(folder: Node2D, row: int) -> Array[Enemy]:
	var result: Array[Enemy] = []
	for node in folder.get_children():
		if not (node is Enemy):
			continue
		var enemy: Enemy = node as Enemy
		if enemy.row != row:
			continue
		result.append(enemy)
	return result
