extends CharacterBody2D

class_name ShadowEnemy

@export var move_speed = 1500.0
@export var row = 0 


var moving: bool = true
var target_tile: GridTile = null

@export var state_machine: StateMachine
@onready var sprite = %Sprite
@onready var health = %Health

func _ready():
    health.set_max_health(100)
    health.set_health(100)

func _physics_process(_delta):
    move_and_slide()

func get_left_tile() -> GridTile:
    var size_x = sprite.texture.get_width() * sprite.scale.x
    var detection_offset = Vector2(-size_x, 0)
    var shadow_left_position: Vector2 = global_position + detection_offset

    var tile: GridTile = GlobalVariables.get_grid().screenspace_to_tile(shadow_left_position)
    return tile

func attack(tile: GridTile) -> bool:
    if tile == null or tile.obstacle == null:
        return false
    tile.obstacle.damage(5)
    return true

func damage(val):
    health.damage(val)
    print(health.health)


func _on_health_death():
    queue_free()
