extends CharacterBody2D

class_name Player

@onready var move_control: PlayerMoveControl = $PlayerMoveControl
@onready var player_resources: PlayerResources = $PlayerResources

func _ready() -> void:
    move_control.initialize()
    player_resources.initialize()

func _physics_process(_delta: float) -> void:
    move_control.update(self)
    pass
