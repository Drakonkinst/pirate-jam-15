extends Node2D

class_name EnemySpawner

@export var shadow_enemy: PackedScene
@onready var spawns_node = %Spawns
@export var spawning_schedule: SpawningSchedule
@export var endless_mode: bool

@onready var num_spawns = len(spawning_schedule.spawns)


enum EnemyType {
	# Sprites
	ShadowSprite,
	AmberSprite,
	QuartzSprite,
	FireSprite,
	StoneSprite,
	# Golems
	ShadowGolem,
	AmberGolem,
	QuartzGolem,
	FireGolem,
	StoneGolem,
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
	if spawned: 
		get_next_spawn_data.call()

func check_spawn() -> bool:
	if game_timer >= next_spawn_time and (current_spawn_idx < num_spawns or endless_mode):
		spawn_enemy(next_spawn_row,next_spawn_scene)
		return true
	return false
	

func spawn_enemy(row: int, enemy_scene: PackedScene):
	var new_enemy = enemy_scene.instantiate()
	new_enemy.position = get_spawn_point_position(row)
	add_child(new_enemy)

func get_spawn_point_position(idx: int):    
	var spawn = spawns_node.get_child(idx)
	print(spawn.name)
	return spawn.global_position

func get_spawn_data():
	var next_spawn = spawning_schedule.spawns[current_spawn_idx]
	next_spawn_time = next_spawn.spawn_time
	next_spawn_scene = spawn_type_to_scene(next_spawn.spawn_type)
	next_spawn_row = next_spawn.row
	if next_spawn_row == SpawnData.RowPosition.Random:
		next_spawn_row = randi_range(0,4)
	current_spawn_idx += 1

# Alternative Endless Strategy
func endless_get_spawn_data():
	next_spawn_scene = spawn_type_to_scene(randi_range(0,EnemyType.values()[randi() % EnemyType.size()]))
	next_spawn_time = game_timer + 1 + (randi() % 2)
	next_spawn_row = randi_range(0,4)

func spawn_type_to_scene(spawn_type):
	var enemy_scene: PackedScene
	match spawn_type:
		EnemyType.ShadowSprite:
			enemy_scene = shadow_enemy
		_:
			enemy_scene = shadow_enemy
	return enemy_scene


