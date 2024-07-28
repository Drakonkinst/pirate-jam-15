extends CharacterBody2D

class_name Enemy

@export var row = 0 
@export var enemy_data: EnemyData

var moving: bool = true
var target_tile: GridTile = null
var is_ally: bool = false

@export var state_machine: StateMachine
@onready var sprite = %Sprite
@onready var health = %Health

func _ready():
	health.set_max_health(enemy_data.health)
	health.set_health(enemy_data.health)

func _physics_process(_delta):
	move_and_slide()

func get_tile_ahead() -> GridTile:
	var size_x = sprite.texture.get_width() * sprite.scale.x
	var detection_offset = Vector2(-size_x / 4, 0)
	var shadow_ahead_position: Vector2
	if is_ally:
		shadow_ahead_position = global_position - detection_offset
	else:
		shadow_ahead_position = global_position + detection_offset

	var tile: GridTile = GlobalVariables.get_grid().screenspace_to_tile(shadow_ahead_position)
	return tile

func get_current_tile() -> GridTile:
	var tile: GridTile = GlobalVariables.get_grid().screenspace_to_tile(global_position)
	return tile

func attack(tile: GridTile) -> bool:
	if tile == null or tile.obstacle == null:
		return false
	tile.obstacle.damage(enemy_data.attack_damage)
	return true

func damage(val):
	health.damage(val)
	print(health.health)


func _on_health_death():
	GlobalVariables.get_pickup_manager().spawn_pickup_drop(Pickup.PickupType.GOLD,global_position,1)
	queue_free()
