extends CharacterBody2D

class_name Player

@onready var move_control: PlayerMoveControl = $PlayerMoveControl

func _ready() -> void:
    move_control.initialize()

func _physics_process(_delta: float) -> void:
    move_control.update(self)
    pass
