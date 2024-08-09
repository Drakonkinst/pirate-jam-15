extends Node2D

class_name InputHandler

var is_using_controller: bool

func _input(event: InputEvent) -> void:
    # print(event.get_class())
    if event is InputEventJoypadButton or event is InputEventJoypadMotion:
        _set_using_controller(true)
    else:
        _set_using_controller(false)

func _set_using_controller(flag: bool) -> void:
    if is_using_controller == flag:
        return
    is_using_controller = flag
    # print("USING CONTROLLER: ", is_using_controller)

