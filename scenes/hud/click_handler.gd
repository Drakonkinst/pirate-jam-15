extends Node2D

class_name ClickHandler

const CLICK_INPUT := "click"

@export var tool_bar: ToolBarHud

var click_pressed: bool = false
func handle_click() -> void:
    var mouse_pos = get_global_mouse_position()
    var success: bool
    success = tool_bar.handle_click(mouse_pos)
    if success:
        return

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed(CLICK_INPUT):
        click_pressed = true
    elif event.is_action_released(CLICK_INPUT):
        click_pressed = false

func _physics_process(_delta: float) -> void:
    if click_pressed:
        handle_click()