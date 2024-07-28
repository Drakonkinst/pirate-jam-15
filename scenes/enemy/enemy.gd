extends CharacterBody2D

class_name Enemy

const DEFAULT_ANIMATION = "default"

@export var row = 0 
@export var enemy_data: EnemyData

var moving: bool = true
var target_tile: GridTile = null
var is_ally: bool = false

@export var state_machine: StateMachine
@onready var sprite: AnimatedSprite2D = %Sprite
@onready var health: Health = %Health
var size_x: float

func _ready():
    health.set_max_health(enemy_data.health)
    health.set_health(enemy_data.health)
    sprite.play(DEFAULT_ANIMATION)
    sprite.pause()
    size_x = sprite.sprite_frames.get_frame_texture(DEFAULT_ANIMATION, 0).get_width() * sprite.scale.x
    state_machine.init()

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
