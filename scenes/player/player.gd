extends CharacterBody2D

class_name Player

@onready var move_control: PlayerMoveControl = $PlayerMoveControl
@onready var player_resources: PlayerResources = $PlayerResources
@onready var animation_control: PlayerAnimationControl = $PlayerAnimationControl

func _ready() -> void:
    move_control.initialize()
    player_resources.initialize()

func _process(_delta: float) -> void:
    animation_control.update_animations(velocity)

func _physics_process(_delta: float) -> void:
    move_control.update(self)

func _on_tool_bar_do_action(tool_type: ToolBar.Tool) -> void:
    if tool_type != ToolBar.Tool.PICKAXE:
        animation_control.do_throw()
