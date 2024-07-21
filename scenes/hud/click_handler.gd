extends Node2D

class_name ClickHandler

const CLICK_INPUT := "click"

@export var tool_bar: ToolBarHud

func handle_click() -> void:
    var mouse_pos = get_global_mouse_position()
    var success: bool
    success = tool_bar.handle_click(mouse_pos)
    if success:
        return

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed(CLICK_INPUT):
        handle_click()
