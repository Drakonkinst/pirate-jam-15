extends Control

func _ready() -> void:
    if OS.has_feature("web"):
        hide()