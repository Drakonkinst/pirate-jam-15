extends CharacterBody2D

class_name ShadowEnemy

@export var move_speed = 1500.0
@export var row = 0 


var moving: bool = true
var obstacle: Obstacle = null

@export var state_machine: StateMachine
@onready var sprite = %Sprite

func _ready():
    pass

func _physics_process(_delta):
    move_and_slide()

func get_left_tile() -> GridTile:
    var size_x = sprite.texture.get_width() * sprite.scale.x
    var detection_offset = Vector2(-size_x, 0)
    var shadow_left_position: Vector2 = global_position + detection_offset

    var tile: GridTile = GlobalVariables.get_grid().screenspace_to_tile(shadow_left_position)
    return tile

func attack(target_obstacle: Obstacle):
    # TODO: Implement small timer
    if target_obstacle != null:
        target_obstacle.damage(5)


