extends Control

class_name ToolInfoHud

@export var name_text: Label
@export var description_text: Label

func set_text(name_s: String, desc: String) -> void:
    name_text.text = name_s
    description_text.text = desc
