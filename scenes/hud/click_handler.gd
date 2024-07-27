extends Node2D

class_name ClickHandler

const CLICK_INPUT := "click"

@export var tool_bar: ToolBarHud

var click_pressed: bool = false
var first_click: bool = true
func handle_click() -> void:
    var mouse_pos = get_global_mouse_position()
    if tool_bar.handle_click(mouse_pos, first_click):
        return

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed(CLICK_INPUT):
        click_pressed = true
    elif event.is_action_released(CLICK_INPUT):
        click_pressed = false
        first_click = true
        tool_bar.off_click()

func _physics_process(_delta: float) -> void:
    if click_pressed:
        handle_click()
        first_click = false