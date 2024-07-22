extends CharacterBody2D

class_name Player

@onready var move_control: PlayerMoveControl = $PlayerMoveControl
@export var player_resources: PlayerResources

func _ready() -> void:
    move_control.initialize()
    GlobalVariables.player_resources = player_resources

func _physics_process(_delta: float) -> void:
    move_control.update(self)
    pass
